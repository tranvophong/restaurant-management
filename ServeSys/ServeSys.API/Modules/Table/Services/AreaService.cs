using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Table.Data;
using ServeSys.API.Modules.Table.DTOs;
using ServeSys.API.Modules.Table.Interfaces;

namespace ServeSys.API.Modules.Table.Services
{
    public class AreaService : IAreaService
    {
        private readonly ILogger<AreaService> _logger;
        private readonly TableDbContext _dbContext;
        public AreaService(ILogger<AreaService> logger, TableDbContext dbContext) 
        {
            _logger = logger;
            _dbContext = dbContext;
        }

        public async Task<IEnumerable<AreaDto>> GetAllAsync(CancellationToken ctk = default)
        {
            var areas = await _dbContext.Areas.AsNoTracking().ToListAsync(ctk);
            return areas.Select(a => new AreaDto 
            {
                Id = a.Id,
                Name = a.Name
            });
        }
    }
}
