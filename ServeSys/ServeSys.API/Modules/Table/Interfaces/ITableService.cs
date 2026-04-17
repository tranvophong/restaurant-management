using ServeSys.API.Modules.Table.DTOs;
using ServeSys.API.Modules.Table.Entities;

namespace ServeSys.API.Modules.Table.Interfaces
{
    public interface ITableService
    {
        Task<IEnumerable<TableDto>> GetTablesByAreaAsync(int areaId);
    }
}
