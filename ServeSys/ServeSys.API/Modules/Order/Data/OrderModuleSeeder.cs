using ServeSys.API.Modules.Order.Entities;

namespace ServeSys.API.Modules.Order.Data
{
    public static class OrderModuleSeeder
    {
        public static async Task SeedAsync(OrderDbContext dbContext)
        {
            await SeedMenuCategoriesAsync(dbContext);
            await dbContext.SaveChangesAsync();
        }

        private static async Task SeedMenuCategoriesAsync(OrderDbContext dbContext)
        {
            if (!dbContext.MenuCategories.Any())
            {
                var categories = new List<MenuCategory>
                {
                    new MenuCategory { Name = "Khai vị", DisplayOrder = 1,
                        IsActive = true },
                    new MenuCategory { Name = "Món chính", DisplayOrder = 2, 
                        IsActive = true },
                    new MenuCategory { Name = "Tráng miệng", DisplayOrder = 3, 
                        IsActive = true },
                    new MenuCategory { Name = "Đồ uống", DisplayOrder = 4, 
                        IsActive = true }
                };
                await dbContext.MenuCategories.AddRangeAsync(categories);
            }
        }
    }
}
