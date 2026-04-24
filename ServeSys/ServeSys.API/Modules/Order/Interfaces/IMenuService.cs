using ServeSys.API.Modules.Order.DTOs;

namespace ServeSys.API.Modules.Order.Interfaces
{
    public interface IMenuService
    {
        Task<IEnumerable<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken = default);
        Task<IEnumerable<MenuItemDto>> GetMenuItemsAsync(CancellationToken cancellationToken = default);
        Task<IEnumerable<MenuItemDto>> GetMenuItemsByCategoryAsync(int categoryId, CancellationToken cancellationToken = default);
    }
}
