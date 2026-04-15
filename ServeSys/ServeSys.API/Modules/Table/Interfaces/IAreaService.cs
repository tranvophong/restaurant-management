using ServeSys.API.Modules.Table.DTOs;

namespace ServeSys.API.Modules.Table.Interfaces
{
    public interface IAreaService
    {
       Task<IEnumerable<AreaDto>> GetAllAsync(CancellationToken ctk = default);
    }
}
