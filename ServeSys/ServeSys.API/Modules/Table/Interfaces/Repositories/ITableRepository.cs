using ServeSys.API.Modules.Table.Entities;
using System.Linq.Expressions;

namespace ServeSys.API.Modules.Table.Interfaces.Repositories
{
    public interface ITableRepository
    {
        Task<IEnumerable<DiningTable>> FindAsync(Expression<Func<DiningTable, bool>>? predicate = null, 
            CancellationToken cancellationToken = default);
    }
}
