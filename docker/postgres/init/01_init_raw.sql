create schema if not exists raw;
create schema if not exists analytics;

create table if not exists raw.customers (
    customer_id integer primary key,
    first_name text not null,
    last_name text not null,
    email text not null,
    signup_date date not null
);

create table if not exists raw.orders (
    order_id integer primary key,
    customer_id integer not null references raw.customers (customer_id),
    order_date date not null,
    amount numeric(10,2) not null,
    status text not null
);

insert into raw.customers (customer_id, first_name, last_name, email, signup_date)
values
    (101, 'Ana', 'Garcia', 'ana.garcia@example.com', '2025-11-03'),
    (102, 'Luis', 'Martinez', 'luis.martinez@example.com', '2025-12-12'),
    (103, 'Elena', 'Lopez', 'elena.lopez@example.com', '2026-01-05');

insert into raw.orders (order_id, customer_id, order_date, amount, status)
values
    (1, 101, '2026-01-10', 120.50, 'completed'),
    (2, 102, '2026-01-11', 89.99, 'pending'),
    (3, 101, '2026-01-15', 45.00, 'completed'),
    (4, 103, '2026-01-20', 210.75, 'cancelled');
