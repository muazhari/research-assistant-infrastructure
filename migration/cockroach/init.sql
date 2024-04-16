drop table if exists account cascade;
create table account
(
    id       uuid primary key,
    email    text not null,
    password text not null
);

drop table if exists session cascade;
create table session
(
    id                       uuid primary key,
    account_id               uuid        not null references account (id) on delete cascade on update cascade,
    access_token             text unique not null,
    refresh_token            text unique not null,
    access_token_expired_at  timestamptz not null,
    refresh_token_expired_at timestamptz not null
);

drop table if exists document_type cascade;
create table document_type
(
    id          text primary key,
    description text not null,
    constraint document_type_id_check check (id in ('text', 'file', 'web'))
);

drop table if exists document cascade;
create table document
(
    id               uuid primary key,
    name             text not null,
    description      text not null,
    document_type_id text not null references document_type (id) on delete cascade on update cascade,
    account_id       uuid not null references account (id) on delete cascade on update cascade

);

drop table if exists document_process cascade;
create table document_process
(
    id                  uuid primary key,
    initial_document_id uuid unique not null references document (id) on delete cascade on update cascade,
    final_document_id   uuid unique not null references document (id) on delete cascade on update cascade,
    started_at          timestamptz not null,
    finished_at         timestamptz not null,
    constraint initial_and_final_document_id_different_check check (initial_document_id != final_document_id)
);


drop table if exists file_document cascade;
create table file_document
(
    id             uuid primary key not null references document (id) on delete cascade on update cascade,
    file_name      text             not null,
    file_data_hash text             not null
);

drop table if exists web_document cascade;
create table web_document
(
    id           uuid primary key not null references document (id) on delete cascade on update cascade,
    web_url      text             not null,
    web_url_hash text             not null
);

drop table if exists text_document cascade;
create table text_document
(
    id                uuid primary key not null references document (id) on delete cascade on update cascade,
    text_content      text             not null,
    text_content_hash text             not null
);

-- populate all table document_types
insert into document_type (id, description)
values ('text', 'description0'),
       ('file', 'description1'),
       ('web', 'description2');

-- playground
select *
from document_process
         inner join document as from_document on from_document.id = document_process.initial_document_id
         inner join document as to_document on to_document.id = document_process.final_document_id
         inner join file_document on file_document.id = document_process.final_document_id
         inner join web_document on web_document.id = document_process.initial_document_id
         inner join document_type as from_document_type on from_document_type.id = from_document.document_type_id
         inner join document_type as to_document_type on to_document_type.id = to_document.document_type_id
         inner join account on account.id = from_document.account_id
         inner join session s on account.id = s.account_id;

select *
from file_document;

select *
from document d
         inner join document_type dt on dt.id = d.document_type_id
         inner join account a on a.id = d.account_id
         inner join text_document td on d.id = td.id
where d.id = 'fb5adc50-df69-4bd0-b4d0-e300d3ff7560';

select *
from document_type;

select *
from account;

select *
from file_document fd;

select *
from document_process dp
where dp.id = '9bff7f89-86de-4a4f-8e41-648b7756d917';

select *
from file_document fd
         inner join document d on fd.id = d.id
         inner join (select a.id
                     from account a
                     where a.id = '0008e915-9337-4ccf-92bd-d89a95f49fca'
                     union
                     select s.account_id
                     from session s
                     where s.id = 'b8859ef0-aeb8-4263-8176-a9f69f7553ba') as a on a.id = d.account_id
where fd.id = '00714e17-45f1-4de2-a7a9-5f138dfdb826';