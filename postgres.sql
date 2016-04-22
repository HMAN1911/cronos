create table events (
  id serial4 primary key,
  start_time timestamptz,
  end_time timestamptz,
  create_time timestamptz,
  user_id integer
);

create table users (
  id serial4 primary key,
  username varchar(50) not null,
  password_digest varchar(100) not null
);
