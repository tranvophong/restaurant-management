using ServeSys.API.Modules.Table.Entities;
using System.Threading.Tasks;

namespace ServeSys.API.Modules.Table.Data
{
    public static class TableModuleSeeder
    {
        public static async Task SeedAsync(TableDbContext dbContext)
        {
            if (!dbContext.Areas.Any())
            {
                var areas = new List<Area>
                {
                    new Area { Name = "Tầng 1", Order = 1, Status = AreaStatus.Active, },
                    new Area { Name = "Tầng 2", Order = 2, Status = AreaStatus.Active },
                    new Area { Name = "Sân thượng", Order = 3, Status = AreaStatus.Active }
                };
                await dbContext.Areas.AddRangeAsync(areas);
                await dbContext.SaveChangesAsync();
            }
        }
    }
}
