using ServeSys.API.Modules.Order.DTOs;
using ServeSys.API.Modules.Order.Entities;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Order.Interfaces.Repositories;
using System.Runtime.ConstrainedExecution;

namespace ServeSys.API.Modules.Order.Services
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly IMenuRepository _menuRepository;
        public OrderService(IOrderRepository orderRepository, IMenuRepository menuRepository)
        {
            _orderRepository = orderRepository;
            _menuRepository = menuRepository;
        }

        public async Task<OrderResponse> PlaceOrderAsync(OrderDto orderDto, CancellationToken cancellationToken = default)
        {
            
            Validate(orderDto);

            // Lấy MenuItem từ database dựa vào danh sách MenuItemId trong orderDto
            // Sau đó chuyển thành dictionary để lookup
            var menuDict = await GetMenuDictionaryAsync(orderDto, cancellationToken);

            // Map Items từ DTO sang Entity, và gán giá lấy từ menuDict đã query db
            var orderItems = BuildOrderItems(orderDto, menuDict);

            var existingOrder = await _orderRepository.GetActiveOrderByTableIdAsync(orderDto.TableId);

            var order = BuildOrder(orderDto, orderItems);

            var savedOrder = existingOrder == null
            ? await _orderRepository.CreateOrderAsync(order, cancellationToken)
            : await _orderRepository.AppendOrderAsync(existingOrder, order, cancellationToken);

            return MapToResponse(savedOrder);
        }

        private void Validate(OrderDto dto)
        {
            if (!dto.Items.Any())
                throw new Exception("Order must have items");

            if (dto.Items.Any(i => i.Quantity <= 0))
                throw new Exception("Quantity must be > 0");
        }

        private async Task<Dictionary<int, MenuItem>> GetMenuDictionaryAsync(
        OrderDto dto,
        CancellationToken cancellationToken)
        {
            var ids = dto.Items.Select(i => i.MenuItemId).ToList();

            var menuItems = (await _menuRepository
                .FindAsync(m => ids.Contains(m.Id), cancellationToken))
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
