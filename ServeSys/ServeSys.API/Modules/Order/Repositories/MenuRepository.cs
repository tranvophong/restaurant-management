using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Order.Data;
using ServeSys.API.Modules.Order.Entities;
using ServeSys.API.Modules.Order.Interfaces.Repositories;
using System.Linq.Expressions;

namespace ServeSys.API.Modules.Order.Repositories
{
    public class MenuRepository : IMenuRepository
    {
        private readonly OrderDbContext _context;
        public MenuRepository(OrderDbContext dbContext) 
        {
            _context = dbContext;
        }


        public async Task<IEnumerable<MenuCategory>> FindCategoriesAsync(Expression<Func<MenuCategory, bool>>? predicate = null, CancellationToken cancellationToken = default)
        {
            if (predicate == null)
            {
                predicate = category => true;
            }
            var categories = await _context.MenuCategories
                .Where(predicate)
                .ToListAsync(cancellationToken);
            return categories;
        }

        public async Task<IEnumerable<MenuItem>> FindAllAsync(Expression<Func<MenuItem, bool>>? predicate = null, CancellationToken cancellationToken = default)
        {
            if (predicate == null)
            {
                predicate = item => true;
            }
            var menuItems = await _context.MenuItems.Where(predicate).ToListAsync(cancellationToken);
            return menuItems;
        }

        public async Task<MenuItem?> FindAsync(Expression<Func<MenuItem, bool>>? predicate = null, CancellationToken cancellationToken = default)
        {
            if (predicate == null)
            {
                predicate = item => true;
            }
            var menuItems = await _context.MenuItems.Where(predicate).FirstOrDefaultAsync(cancellationToken);
            return menuItems;
        }
    }
}
