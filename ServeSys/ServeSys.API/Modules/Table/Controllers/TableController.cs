using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServeSys.API.Modules.Shared.DTOs;
using ServeSys.API.Modules.Table.DTOs;
using ServeSys.API.Modules.Table.Interfaces;

namespace ServeSys.API.Modules.Table.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TableController : ControllerBase
    {
        private readonly ILogger<TableController> _logger;
        private readonly ITableService _tableService;

        public TableController(ILogger<TableController> logger, ITableService tableService)
        {
            _logger = logger;
            _tableService = tableService;
        }


        [HttpGet("{areaId:int?}")]
        public async Task<IActionResult> GetTablesByArea(int? areaId, CancellationToken ctk)
        {
            if(areaId == null)
            {
                return BadRequest(ApiResponse.Fail("Area is required."));
            }
            if(areaId < -1 || areaId == 0)
            {
                return BadRequest(ApiResponse.Fail("Invalid area ID."));
            }
            var tables = areaId == -1
                ? await _tableService.GetTablesAsync(ctk)
                : await _tableService.GetTablesByAreaAsync(areaId.Value, ctk);
            return Ok(ApiResponse<IEnumerable<TableDto>>.Ok(tables));
        }
    }
}
