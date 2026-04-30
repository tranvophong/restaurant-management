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

        public async Task<TableDto?> GetByIdAsync(int tableId, CancellationToken cancellationToken = default)
        {
            var table = await _tableRepository.FindAsync(t => t.Id == tableId, cancellationToken);
            return table != null ? new TableDto
            {
                Id = table.Id,
                Name = table.Name,
                Seats = table.Capacity,
                Status = table.Status
            } : null;
        }

        public async Task<bool> OccupyTableAsync(int tableId, CancellationToken cancellationToken = default)
        {
            var hasAffected = await _tableRepository.UpdateAsync(t => t.Id == tableId && t.Status == TableStatus.Available,
                s => s.SetProperty(t => t.Status, TableStatus.Occupied)
                      .SetProperty(t => t.UpdatedAt, DateTime.UtcNow)
                , cancellationToken); 
            return hasAffected;
        }

        public async Task<IEnumerable<TableDto>> GetTablesAsync(CancellationToken ctk = default)
        {
            var tables = await _tableRepository.FindAllAsync(cancellationToken: ctk);
            return tables.Select(t => new TableDto
            {
                Id = t.Id,
                Name = t.Name,
                Seats = t.Capacity,
                Status = t.Status
            });
        }

        public async Task<IEnumerable<TableDto>> GetTablesByAreaAsync(int areaId, CancellationToken ctk = default)
        {
            var tables = await _tableRepository.FindAllAsync(t => t.AreaId == areaId, ctk);
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
