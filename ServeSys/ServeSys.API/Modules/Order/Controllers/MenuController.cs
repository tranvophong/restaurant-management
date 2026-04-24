using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServeSys.API.Modules.Order.DTOs;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Shared.DTOs;

namespace ServeSys.API.Modules.Order.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MenuController : ControllerBase
    {
        private readonly IMenuService _menuService;
        public MenuController(IMenuService menuService)
        {
            _menuService = menuService;
        }


        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories(CancellationToken cancellationToken)
        {
            var categories = await _menuService.GetCategoriesAsync(cancellationToken);
            return Ok(ApiResponse<IEnumerable<CategoryDto>>.Ok(categories));
        }

        [HttpGet("{categoryId:int?}")]
        public async Task<IActionResult> GetMenuItems(int? categoryId, CancellationToken cancellationToken)
        {
            if(categoryId.HasValue && categoryId < -1)
            {
                return BadRequest(ApiResponse.Fail("Invalid category"));
            }

            var menuItems = categoryId == -1 
                ? await _menuService.GetMenuItemsAsync(cancellationToken) 
                : await _menuService.GetMenuItemsByCategoryAsync(categoryId!.Value, cancellationToken);
            return Ok(ApiResponse<IEnumerable<MenuItemDto>>.Ok(menuItems));
        }
    }
}
