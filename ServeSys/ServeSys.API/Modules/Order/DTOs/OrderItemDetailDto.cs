using ServeSys.API.Modules.Order.Entities;

namespace ServeSys.API.Modules.Order.DTOs
{
    public class OrderItemDetailDto
    {
        public int MenuItemId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string ImageUrl { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public string? Notes { get; set; }
        public decimal Price { get; set; }
        public string StaffName { get; set; } = string.Empty;
        public OrderItemStatus Status { get; set; }

        public DateTime OrderAt { get; set; }

    }
}
