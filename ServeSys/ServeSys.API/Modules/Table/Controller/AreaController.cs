using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServeSys.API.Modules.Shared.DTOs;
using ServeSys.API.Modules.Table.DTOs;
using ServeSys.API.Modules.Table.Interfaces;

namespace ServeSys.API.Modules.Table.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class AreaController : ControllerBase
    {
        private readonly ILogger<AreaController> _logger;
        private readonly IAreaService _areaService;
        public AreaController(ILogger<AreaController> logger, IAreaService areaService)
        {
            _logger = logger;
            _areaService = areaService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAreas(CancellationToken ctk)
        {
            var areas = await _areaService.GetAllAsync(ctk);
            return Ok(ApiResponse<IEnumerable<AreaDto>>.Ok(areas));
        }
    }
}
