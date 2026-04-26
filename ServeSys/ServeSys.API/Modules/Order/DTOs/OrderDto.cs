using ServeSys.API.Modules.Order.Entities;

namespace ServeSys.API.Modules.Order.DTOs
{
    public class OrderDto
    {
        public string StaffId { get; set; } = string.Empty;
        public string StaffName { get; set; } = string.Empty;
        public int TableId { get; set; }
        public string? Notes { get; set; }
        public IEnumerable<OrderItemDto> Items { get; set; } = Enumerable.Empty<OrderItemDto>();
    }

    public class OrderRequest
    {
        public int TableId { get; set; }
        public string? Notes { get; set; }
        public IEnumerable<OrderItemDto> Items { get; set; } = Enumerable.Empty<OrderItemDto>();
    }

    public class OrderResponse
    {
        public string OrderCode { get; set; } = string.Empty;
        public string StaffName { get; set; } = string.Empty;
        public int TableId { get; set; }
        public string? Notes { get; set; }
        public decimal TotalAmount { get; set; }
        public OrderStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }

        public IEnumerable<OrderItemResponse> Items { get; set; } = new List<OrderItemResponse>();
    }

    public class OrderItemResponse
    {
        public int MenuItemId { get; set; }
        public string StaffName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public string? Notes { get; set; }
        public OrderItemStatus Status { get; set; }
    }
}
