using ServeSys.API.Modules.Table.DTOs;
using ServeSys.API.Modules.Table.Entities;
using ServeSys.API.Modules.Table.Interfaces;
using ServeSys.API.Modules.Table.Interfaces.Repositories;
using ServeSys.API.Modules.Table.Repositories;

namespace ServeSys.API.Modules.Table.Services
{
    public class TableService : ITableService
    {
        private readonly ITableRepository _tableRepository;
        public TableService(ITableRepository tableRepository)
        {
            _tableRepository = tableRepository;
        }
        public async Task<IEnumerable<TableDto>> GetTablesByAreaAsync(int areaId)
        {
            var tables = await _tableRepository.GetTablesByAreaAsync(areaId);
            return tables.Select(t => new TableDto
            {
                Id = t.Id,
                Name = t.Name,
                Seats = t.Capacity,
                Status = t.Status
            });
        }
    }
}
