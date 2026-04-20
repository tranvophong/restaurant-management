using Microsoft.EntityFrameworkCore;
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

            if (!dbContext.DiningTables.Any())
            {
                var areas = await dbContext.Areas.ToListAsync();
                var tables = new List<DiningTable>
                {
                    new DiningTable { Name = "Bàn 1", AreaId = areas[0].Id, Capacity = 20, Status = TableStatus.Occupied },
                    new DiningTable { Name = "Bàn 2", AreaId = areas[1].Id, Capacity = 30, Status = TableStatus.Available },
                    new DiningTable { Name = "Bàn 3", AreaId = areas[2].Id, Capacity = 25, Status = TableStatus.Reserved }
                };
                await dbContext.DiningTables.AddRangeAsync(tables);
                await dbContext.SaveChangesAsync();
            }
        }
    }
}
