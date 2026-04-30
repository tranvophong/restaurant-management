using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using ServeSys.API.Modules.Order.DTOs;

namespace ServeSys.API.Modules.Order.Interfaces
{
    public interface IOrderService
    {
       Task<OrderResponse> PlaceOrderAsync(OrderDto orderDto, CancellationToken cancellationToken = default);
       Task<OrderDetailDto> GetOrderByTableAsync(int tableId, CancellationToken cancellationToken = default);
    }
}
