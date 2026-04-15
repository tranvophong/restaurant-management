using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Identity.Entities;

namespace ServeSys.API.Modules.Identity.Data;

public class IdentityDbContext : IdentityDbContext<User>
{
    public IdentityDbContext(DbContextOptions<IdentityDbContext> options)
        : base(options)
    {
    }

    public DbSet<RefreshToken> RefreshTokens { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        // Configure User entity
        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users");
            entity.Property(u => u.FullName).HasMaxLength(100);
            entity.Property(u => u.AvatarUrl).HasMaxLength(200);
            entity.Property(u => u.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        });

        // Configure RefreshToken entity
        modelBuilder.Entity<RefreshToken>(entity =>
        {
            entity.ToTable("RefreshTokens");
            entity.HasOne(rt => rt.User)
                .WithMany(u => u.RefreshTokens)
                .HasForeignKey(rt => rt.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.Property(rt => rt.Token).IsRequired().HasMaxLength(500);
            entity.Property(rt => rt.Expires).IsRequired();
            entity.Property(rt => rt.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            entity.Property(rt => rt.ReplacedByToken).HasMaxLength(500);
            entity.Property(rt => rt.RevokedAt);
            entity.Ignore(rt => rt.IsExpired);
            entity.Ignore(rt => rt.IsRevoked);
            entity.Ignore(rt => rt.IsActive);

            entity.HasIndex(rt => rt.Token).IsUnique();
        });


        // Seed an initial admin user
        var hasher = new PasswordHasher<User>();
        var adminUser = new User
        {
            UserName = "admin@servesys.com",
            NormalizedUserName = "ADMIN@SERVESYS.COM",
            Email = "admin@servesys.com",
            NormalizedEmail = "ADMIN@SERVESYS.COM",
            EmailConfirmed = true,
            FullName = "System Admin",
            AvatarUrl = "",
            CreatedAt = DateTime.UtcNow,
            SecurityStamp = Guid.NewGuid().ToString("D"),
            ConcurrencyStamp = Guid.NewGuid().ToString("D")
        };
        adminUser.PasswordHash = hasher.HashPassword(adminUser, "admin@123");
        modelBuilder.Entity<User>().HasData(adminUser);
    }
}
