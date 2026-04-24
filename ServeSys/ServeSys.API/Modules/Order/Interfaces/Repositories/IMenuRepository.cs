using ServeSys.API.Modules.Order.Entities;
using System.Linq.Expressions;

namespace ServeSys.API.Modules.Order.Interfaces.Repositories
{
    public interface IMenuRepository
    {
        Task<IEnumerable<MenuCategory>> FindCategoriesAsync(Expression<Func<MenuCategory, bool>>? predicate = null,
            CancellationToken cancellationToken = default);
        Task<IEnumerable<MenuItem>> FindAsync(Expression<Func<MenuItem, bool>>? predicate = null, 
            CancellationToken cancellationToken = default);
    }
}
