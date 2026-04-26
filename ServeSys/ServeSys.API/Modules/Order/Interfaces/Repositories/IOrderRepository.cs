namespace ServeSys.API.Modules.Order.Interfaces.Repositories
{
    public interface IOrderRepository
    {
        Task<Entities.Order> CreateOrderAsync(Entities.Order order, CancellationToken cancellationToken = default);
        Task<Entities.Order?> GetActiveOrderByTableIdAsync(int tableId, CancellationToken cancellationToken = default);
        Task<Entities.Order> AppendOrderAsync(Entities.Order existingOrder, Entities.Order incomingOrder, CancellationToken cancellationToken = default);
    }
}
