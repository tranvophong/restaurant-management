using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Order.Data;
using ServeSys.API.Modules.Order.Entities;
using ServeSys.API.Modules.Order.Interfaces.Repositories;

namespace ServeSys.API.Modules.Order.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        private readonly OrderDbContext _context;
        public OrderRepository(OrderDbContext context)
        {
            _context = context;
        }

        public async Task<Entities.Order> AppendOrderAsync(Entities.Order existingOrder, Entities.Order incomingOrder, CancellationToken cancellationToken = default)
        {
            await _context.Entry(existingOrder)
                .Collection(o => o.OrderItems).LoadAsync(cancellationToken);

            foreach (var newItem in incomingOrder.OrderItems)
            {
                if (newItem.Quantity <= 0)
                    continue;

                var existingItem = existingOrder.OrderItems.FirstOrDefault(oi => oi.MenuItemId == newItem.MenuItemId);
                if (existingItem == null)
                {
                    existingOrder.OrderItems.Add(new OrderItem
                    {
                        MenuItemId = newItem.MenuItemId,
                        Quantity = newItem.Quantity,
                        UnitPrice = newItem.UnitPrice,
                        Notes = newItem.Notes,
                        Status = OrderItemStatus.Pending,
                        StaffId = newItem.StaffId,
                        StaffName = newItem.StaffName,
                        CreatedAt = DateTime.UtcNow
                    });
                }
                else
                {
                    existingItem.Quantity += newItem.Quantity;
                    existingItem.UpdatedAt = DateTime.UtcNow;
                }
            }
            existingOrder.TotalAmount = existingOrder.OrderItems
                                         .Sum(i => i.Quantity * i.UnitPrice);
            existingOrder.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync(cancellationToken);
            return existingOrder;
        }

        public async Task<Entities.Order> CreateOrderAsync(Entities.Order order, CancellationToken cancellationToken = default)
        {
            order.CreatedAt = DateTime.UtcNow;
            var orderEntity = await _context.Orders.AddAsync(order, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
            return orderEntity.Entity;
        }

        public async Task<Entities.Order?> GetActiveOrderByTableIdAsync(int tableId, CancellationToken cancellationToken = default)
        {
            return await _context.Orders.Where(o => o.DiningTableId == tableId && o.Status != OrderStatus.Cancelled
            && o.Status != OrderStatus.Completed)
                .OrderByDescending(o => o.CreatedAt)
                .FirstOrDefaultAsync(cancellationToken);
        }
    }
}
