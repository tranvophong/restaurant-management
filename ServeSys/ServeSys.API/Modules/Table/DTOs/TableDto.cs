using ServeSys.API.Modules.Table.Entities;
using System.Text.Json.Serialization;

namespace ServeSys.API.Modules.Table.DTOs
{
    public class TableDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Seats { get; set; }

        [JsonConverter(typeof(JsonStringEnumConverter))]
        public TableStatus Status { get; set; }
        public bool IsAvailable => Status == TableStatus.Available;
    }
}
