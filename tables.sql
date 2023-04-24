create table addresses(
    customer_id number primary key references customers(customer_id), 
    city varchar2(100), 
    street varchar2(100), 
    house_number number, 
    flat_number number
)
create table authors(
    author_id number primary key, 
    firstname varchar2(255), 
    lastname varchar2(255), 
    country varchar2(255)
)
create table books(
    book_id number primary key, 
    title varchar2(255), 
    foreign key author_id references authors(author_id), 
    foreign key publisher_id references publishers(publisher_id), 
    publishdate date,
    pages number, 
    price number, 
    isbn varchar2(255),
    cover varchar2(255),
    stock number
)
create table cart(
    cart_id number primary key, 
    foreign key customer_id references customers(customer_id) number, 
    foreign key book_id references books(book_id), 
    quantity number
)
create table customers(
    customer_id number primary key, 
    firstname varchar2(255), 
    lastname varchar2(255), 
    phone varchar2(255),
    email varchar2(255)
)
create table favourites(
    favourite_id number primary key, 
    foreign key customer_id references customers(customer_id),
    foreign key book_id references books(book_id)
)
create table orders(
    order_id number primary key, 
    foreign key customer_id references customers(customer_id),
    orderdate date,
    totalamount number(10, 2),
    additional varchar(255),
    status varchar(255),
    payment_method varchar(255),
    payment_status varchar(255)
)
create table order_items(
    order_item_id number primary key, 
    foreign key order_id references orders(order_id),
    foreign key book_id references books(book_id),
    quantity number
)
create table publishers(
    publisher_id number primary key, 
    name varchar2(255),
    phone varchar2(255),
    city varchar2(100),
    street varchar2(100),
    street_number number
)
create table reviews(
    review_id number primary key, 
    foreign key customer_id references customers(customer_id),
    foreign key book_id references books(book_id),
    description varchar2(1000)
)
create table sales(
    sale_id number primary key, 
    foreign key book_id references books(book_id),
    foreign key customer_id references customers(customer_id),
    saledate date, 
    quantity number, 
    foreign key order_id references orders(order_id)
)



