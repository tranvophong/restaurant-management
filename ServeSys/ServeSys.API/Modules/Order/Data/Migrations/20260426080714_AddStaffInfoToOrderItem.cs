using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ServeSys.API.Modules.Order.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddStaffInfoToOrderItem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "StaffId",
                table: "OrderItems",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "StaffName",
                table: "OrderItems",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StaffId",
                table: "OrderItems");

            migrationBuilder.DropColumn(
                name: "StaffName",
                table: "OrderItems");
        }
    }
}
