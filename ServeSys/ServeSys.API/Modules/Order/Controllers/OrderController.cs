using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using ServeSys.API.Modules.Order.DTOs;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Shared.DTOs;
using ServeSys.API.Modules.Shared.Exceptions;
using System.Security.Claims;

namespace ServeSys.API.Modules.Order.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly IOrderService _orderService;
        public OrderController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        [HttpPost("place")]
        public async Task<IActionResult> PlaceOrder(OrderRequest orderRequest, CancellationToken cancellationToken)
        {
            if (!orderRequest.Items.Any())
                return BadRequest(ApiResponse.Fail("Order must have items"));
            try
            {
                var staffId = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
                var staffName = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Name)?.Value;
                var orderDto = new OrderDto
                {
                    StaffId = staffId,
                    StaffName = staffName,
                    TableId = orderRequest.TableId,
                    Notes = orderRequest.Notes,
                    Items = orderRequest.Items
                };
                var order = await _orderService.PlaceOrderAsync(orderDto, cancellationToken);
                return Ok(ApiResponse<OrderResponse>.Ok(order));
            }
            catch (BadRequestException ex)
            {
                return BadRequest(ApiResponse.Fail(ex.Message));
            }
            catch (NotFoundException ex)
            {
                return NotFound(ApiResponse.Fail(ex.Message));
            }
            catch (ConflictException ex)
            {
                return Conflict(ApiResponse.Fail(ex.Message));
            }
            catch (Exception)
            {
                return StatusCode(500, ApiResponse.Fail("Internal server error"));
            }
        }
    }
}
