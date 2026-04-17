using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Table.Data;
using ServeSys.API.Modules.Table.Entities;
using ServeSys.API.Modules.Table.Interfaces.Repositories;

namespace ServeSys.API.Modules.Table.Repositories
{
    public class TableRepository : ITableRepository
    {
        private readonly TableDbContext _context;
        public TableRepository(TableDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<DiningTable>> GetTablesByAreaAsync(int areaId)
        {
            var tables = await _context.DiningTables.Where(t => t.AreaId == areaId).ToListAsync();
            return tables;
        }
    }
}
