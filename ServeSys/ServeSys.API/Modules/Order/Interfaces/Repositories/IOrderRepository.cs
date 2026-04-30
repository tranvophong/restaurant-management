using System.Linq.Expressions;

namespace ServeSys.API.Modules.Order.Interfaces.Repositories
{
    public interface IOrderRepository
    {
        Task<Entities.Order?> FindAsync(Expression<Func<Entities.Order, bool>> predicate,
        Func<IQueryable<Entities.Order>, IOrderedQueryable<Entities.Order>>? orderBy = null,
        Func<IQueryable<Entities.Order>, IQueryable<Entities.Order>>? include = null,
        CancellationToken cancellationToken = default);

        Task<Entities.Order> CreateOrderAsync(Entities.Order order, CancellationToken cancellationToken = default);
        Task<Entities.Order?> GetActiveOrderByTableIdAsync(int tableId, CancellationToken cancellationToken = default);
        Task<Entities.Order> AppendOrderAsync(Entities.Order existingOrder, Entities.Order incomingOrder, CancellationToken cancellationToken = default);
    }
}
