using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using ServeSys.API.Modules.Order.Data;
using ServeSys.API.Modules.Order.DTOs;
using ServeSys.API.Modules.Order.Entities;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Order.Interfaces.Repositories;
using ServeSys.API.Modules.Shared.Exceptions;
using ServeSys.API.Modules.Table.Interfaces;
using System.Runtime.ConstrainedExecution;

namespace ServeSys.API.Modules.Order.Services
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly IMenuRepository _menuRepository;
        private readonly ITableService _tableService;
        private readonly OrderDbContext _orderContext;
        public OrderService(IOrderRepository orderRepository, IMenuRepository menuRepository, ITableService tableService, OrderDbContext orderContext)
        {
            _orderRepository = orderRepository;
            _menuRepository = menuRepository;
            _tableService = tableService;
            _orderContext = orderContext;
        }

        public async Task<OrderDetailDto> GetOrderByTableAsync(int tableId, CancellationToken cancellationToken = default)
        {
            var order = await _orderRepository.FindAsync(o => o.DiningTableId == tableId 
            && o.Status != OrderStatus.Completed 
            && o.Status != OrderStatus.Cancelled, 
            orderBy: o => o.OrderByDescending(or => or.CreatedAt),
            include: o => o.Include(or => or.OrderItems).ThenInclude(oi => oi.MenuItem),
            cancellationToken: cancellationToken);
            if (order == null) throw new NotFoundException("Order not found");

            return new OrderDetailDto
            {
                OrderCode = order.OrderCode,
                TableId = order.DiningTableId,
                Notes = order.Notes ?? string.Empty,
                TotalPrice = order.TotalAmount,
                Items = order.OrderItems.Select(i => new OrderItemDetailDto
                {
                    MenuItemId = i.MenuItemId,
                    Description = i.MenuItem.Description ?? "",
                    ImageUrl = i.MenuItem.ImageUrl ?? "",
                    Title = i.MenuItem.Name,
                    Quantity = i.Quantity,
                    Price = i.UnitPrice,
                    OrderAt = i.CreatedAt,
                    Status = i.Status,
                    StaffName = i.StaffName,
                    Notes = i.Notes ?? string.Empty,
                    
                }).ToList(),
                CreatedAt = order.CreatedAt
            };
        }

        public async Task<OrderResponse> PlaceOrderAsync(OrderDto orderDto, CancellationToken cancellationToken = default)
        {

            ValidateModel(orderDto);

            using var transaction = await _orderContext.Database.BeginTransactionAsync(cancellationToken);
            try
            {
                var tableOrder = await _tableService.GetByIdAsync(orderDto.TableId);
                if (tableOrder == null)
                    throw new NotFoundException("Table not found");

                if (!tableOrder.IsAvailable)
                    throw new ConflictException("Table is not available");

                var existingOrder = await _orderRepository.GetActiveOrderByTableIdAsync(orderDto.TableId, cancellationToken);
                await EnsureTableReadyForOrderAsync(tableOrder.Id, existingOrder, cancellationToken);

                // Lấy MenuItem từ database dựa vào danh sách MenuItemId trong orderDto
                // Sau đó chuyển thành dictionary để lookup
                var menuDict = await GetMenuDictionaryAsync(orderDto, cancellationToken);

                // Map Items từ DTO sang Entity, và gán giá lấy từ menuDict đã query db
                var orderItems = BuildOrderItems(orderDto, menuDict);

                var order = BuildOrder(orderDto, orderItems);
                
                var savedOrder = existingOrder == null
                ? await _orderRepository.CreateOrderAsync(order, cancellationToken)
                : await _orderRepository.AppendOrderAsync(existingOrder, order, cancellationToken);

                await transaction.CommitAsync(cancellationToken);
                return MapToResponse(savedOrder);
            }
            catch (Exception)
            {
                await transaction.RollbackAsync(cancellationToken);
                throw;
            }
        }

        private async Task EnsureTableReadyForOrderAsync(
            int tableId,
            Entities.Order? existingOrder,
            CancellationToken cancellationToken)
        {
            // bàn chưa có order → phải đổi trạng thái bàn
            if (existingOrder == null)
            {
                var isOccupied = await _tableService
                    .OccupyTableAsync(tableId, cancellationToken);

                if (!isOccupied)
                    throw new ConflictException("Table is not available");

                return;
            }

            // đã có order → phải còn active
            if (existingOrder.Status == OrderStatus.Completed ||
                existingOrder.Status == OrderStatus.Cancelled)
            {
                throw new ConflictException("Cannot append to a closed order");
            }
        }

        private void ValidateModel(OrderDto dto)
        {
            if (!dto.Items.Any())
                throw new BadRequestException("Order must have items");

            if (dto.Items.Any(i => i.Quantity <= 0))
                throw new BadRequestException("Quantity must be > 0");
        }

        private async Task<Dictionary<int, MenuItem>> GetMenuDictionaryAsync(
        OrderDto dto,
        CancellationToken cancellationToken)
        {
            var ids = dto.Items.Select(i => i.MenuItemId).ToList();

            var menuItems = (await _menuRepository
                .FindAllAsync(m => ids.Contains(m.Id), cancellationToken))
                .ToList();

            if (menuItems.Count != ids.Count)
                throw new Exception("Invalid menu item");

            return menuItems.ToDictionary(m => m.Id);
        }

        private Entities.Order BuildOrder(OrderDto dto, List<OrderItem> items)
        {
            var order = new Entities.Order
            {
                OrderCode = $"ORD-{DateTime.Now:yyyyMMddHHmmss}",
                StaffId = dto.StaffId,
                StaffName = dto.StaffName,
                DiningTableId = dto.TableId,
                Notes = dto.Notes,
                OrderItems = items,
                Status = OrderStatus.Pending
            };

            order.TotalAmount = items.Sum(i => i.Quantity * i.UnitPrice);
            return order;
        }

        private List<OrderItem> BuildOrderItems(
        OrderDto dto,
        Dictionary<int, MenuItem> menuDict)
        {
            return dto.Items.Select(i =>
            {
                var menu = menuDict[i.MenuItemId];

                return new OrderItem
                {
                    MenuItemId = menu.Id,
                    Quantity = i.Quantity,
                    UnitPrice = menu.Price,
                    Status = OrderItemStatus.Pending,
                    Notes = i.Notes,
                    StaffId = dto.StaffId,
                    StaffName = dto.StaffName,
                };
            }).ToList();
        }

        private OrderResponse MapToResponse(Entities.Order order)
        {
            return new OrderResponse
            {
                OrderCode = order.OrderCode,
                Status = order.Status,
                Notes = order.Notes,
                TotalAmount = order.TotalAmount,
                StaffName = order.StaffName,
                TableId = order.DiningTableId,
                Items = order.OrderItems.Select(oi => new OrderItemResponse
                {
                    MenuItemId = oi.MenuItemId,
                    Quantity = oi.Quantity,
                    UnitPrice = oi.UnitPrice,
                    Notes = oi.Notes,
                    StaffName = oi.StaffName,
                    Status = oi.Status
                }).ToList()
            };
        }
    }
}
