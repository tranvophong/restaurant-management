using ServeSys.API.Modules.Table.Entities;

namespace ServeSys.API.Modules.Table.Interfaces.Repositories
{
    public interface ITableRepository
    {
        Task<IEnumerable<DiningTable>> GetTablesByAreaAsync(int areaId);
    }
}
