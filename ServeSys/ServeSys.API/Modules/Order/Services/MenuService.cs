using ServeSys.API.Modules.Order.DTOs;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Order.Interfaces.Repositories;

namespace ServeSys.API.Modules.Order.Services
{
    public class MenuService : IMenuService
    {
        private readonly IMenuRepository _menuRepository;
        public MenuService(IMenuRepository menuRepository)
        {
            _menuRepository = menuRepository;
        }

        public async Task<IEnumerable<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken = default)
        {
            var menuCategories = await _menuRepository.FindCategoriesAsync(cancellationToken: cancellationToken);
            return menuCategories.Select(category => new CategoryDto
            {
                Id = category.Id,
                Name = category.Name,
                Description = category.Description,
                DisplayOrder = category.DisplayOrder,
                IsActive = category.IsActive,
            });
        }

        public async Task<IEnumerable<MenuItemDto>> GetMenuItemsAsync(CancellationToken cancellationToken = default)
        {
            var menuItems = await _menuRepository.FindAsync(cancellationToken: default);
            return menuItems.Select(item => new MenuItemDto
            {
                Id = item.Id,
                Name = item.Name,
                Description = item.Description,
                Price = item.Price,
                ImageUrl = item.ImageUrl,
                DisplayOrder = item.DisplayOrder,
                IsAvailable = item.IsAvailable,
                IsBestSeller = item.IsBestSeller
            });
        }

        public async Task<IEnumerable<MenuItemDto>> GetMenuItemsByCategoryAsync(int categoryId, CancellationToken cancellationToken = default)
        {
            var menuItems = await _menuRepository.FindAsync(item => item.MenuCategoryId == categoryId, cancellationToken);
            return menuItems.Select(item => new MenuItemDto
            {
                Id = item.Id,
                Name = item.Name,
                Description = item.Description,
                Price = item.Price,
                ImageUrl = item.ImageUrl,
                DisplayOrder = item.DisplayOrder,
                IsAvailable = item.IsAvailable,
                IsBestSeller = item.IsBestSeller
            });
        }
    }
}
