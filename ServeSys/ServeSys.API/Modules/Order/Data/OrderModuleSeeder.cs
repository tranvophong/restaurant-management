using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Order.Entities;

namespace ServeSys.API.Modules.Order.Data
{
    public static class OrderModuleSeeder
    {
        public static async Task SeedAsync(OrderDbContext dbContext)
        {
            await SeedMenuCategoriesAsync(dbContext);
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
                await dbContext.SaveChangesAsync();
            }

            if (!dbContext.MenuItems.Any())
            {
                var categories = await dbContext.MenuCategories.ToListAsync();
                var khaiVi = categories.First(c => c.Name.ToLower() == "khai vị");
                var monChinh = categories.First(c => c.Name.ToLower() == "món chính");
                var trangMieng = categories.First(c => c.Name.ToLower() == "tráng miệng");
                var doUong = categories.First(c => c.Name.ToLower() == "đồ uống");

                var items = new List<MenuItem>
                {
                    // Khai vị
                    new MenuItem { Name = "Gỏi cuốn tôm thịt", Price = 45000,
                        Description = "Gỏi cuốn tươi với tôm, thịt heo, bún và rau sống",
                        MenuCategoryId = khaiVi.Id, DisplayOrder = 1 },
                    new MenuItem { Name = "Chả giò chiên", Price = 55000,
                        Description = "Chả giò giòn rụm nhân thịt heo và rau củ",
                        MenuCategoryId = khaiVi.Id, DisplayOrder = 2 },
                    new MenuItem { Name = "Súp bào ngư", Price = 85000,
                        Description = "Súp bào ngư thượng hạng nấu cùng nấm đông cô",
                        MenuCategoryId = khaiVi.Id, DisplayOrder = 3 },

                    // Món chính
                    new MenuItem { Name = "Cơm chiên dương châu", Price = 75000,
                        Description = "Cơm chiên với trứng, lạp xưởng, tôm và rau củ",
                        MenuCategoryId = monChinh.Id, DisplayOrder = 1 },
                    new MenuItem { Name = "Phở bò tái", Price = 65000,
                        Description = "Phở bò truyền thống với nước dùng hầm xương 12 tiếng",
                        MenuCategoryId = monChinh.Id, DisplayOrder = 2 },
                    new MenuItem { Name = "Bún bò Huế", Price = 70000,
                        Description = "Bún bò Huế cay nồng đậm đà hương vị miền Trung",
                        MenuCategoryId = monChinh.Id, DisplayOrder = 3 },
                    new MenuItem { Name = "Cá kho tộ", Price = 95000,
                        Description = "Cá lóc kho tộ đất với nước màu dừa và tiêu",
                        MenuCategoryId = monChinh.Id, DisplayOrder = 4 },

                    // Tráng miệng
                    new MenuItem { Name = "Chè ba màu", Price = 30000,
                        Description = "Chè đậu đỏ, đậu xanh, nước cốt dừa",
                        MenuCategoryId = trangMieng.Id, DisplayOrder = 1 },
                    new MenuItem { Name = "Bánh flan", Price = 25000,
                        Description = "Bánh flan caramel mềm mịn béo ngậy",
                        MenuCategoryId = trangMieng.Id, DisplayOrder = 2 },

                    // Đồ uống
                    new MenuItem { Name = "Trà đào cam sả", Price = 35000,
                        Description = "Trà đào tươi mát với cam và sả",
                        MenuCategoryId = doUong.Id, DisplayOrder = 1 },
                    new MenuItem { Name = "Cà phê sữa đá", Price = 29000,
                        Description = "Cà phê phin truyền thống pha sữa đặc",
                        MenuCategoryId = doUong.Id, DisplayOrder = 2 },
                    new MenuItem { Name = "Nước ép dưa hấu", Price = 32000,
                        Description = "Nước ép dưa hấu tươi nguyên chất",
                        MenuCategoryId = doUong.Id, DisplayOrder = 3 }
                };
                await dbContext.MenuItems.AddRangeAsync(items);
                await dbContext.SaveChangesAsync();
            }
        }
    }
}
