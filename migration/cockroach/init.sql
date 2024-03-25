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
    constraint initial_and_final_document_id_different_check check (initial_document_id != final_document_id
        )
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
--
-- -- populate all table accounts
-- insert into account (id, email, password)
-- values ('db5adc50-df69-4bd0-b4d0-e300d3ff7560', 'admin@mail.com', 'admin'),
--        ('db5adc50-df69-4bd0-b4d0-e300d3ff7561', 'user@mail.com', 'user');
--
-- -- populate all table sessions
-- insert into session (id, account_id, access_token, refresh_token, access_token_expired_at, refresh_token_expired_at)
-- values ('1256e621-11d0-4325-8350-4b64c57c5c30', 'db5adc50-df69-4bd0-b4d0-e300d3ff7560',
--         'c9948deb-784c-4705-b93b-8c2c53a31530', '2b97a983-fd30-41ec-a350-3621ffed2ce0', now()::timestamptz,
--         now()::timestamptz),
--        ('1256e621-11d0-4325-8350-4b64c57c5c31', 'db5adc50-df69-4bd0-b4d0-e300d3ff7561',
--         'c9948deb-784c-4705-b93b-8c2c53a31531', '2b97a983-fd30-41ec-a350-3621ffed2ce1', now()::timestamptz,
--         now()::timestamptz);
--
-- populate all table document_types
insert into document_type (id, description)
values ('text', 'text description'),
       ('file', 'file description'),
       ('web', 'web description');
--
-- -- populate table documents and its sub tables
-- insert into document (id, name, description, document_type_id, account_id)
-- values ('fb5adc50-df69-4bd0-b4d0-e300d3ff7560', 'text document', 'text description',
--         'text', 'db5adc50-df69-4bd0-b4d0-e300d3ff7560'),
--        ('fb5adc50-df69-4bd0-b4d0-e300d3ff7561', 'file document', 'file description',
--         'file', 'db5adc50-df69-4bd0-b4d0-e300d3ff7560'),
--        ('fb5adc50-df69-4bd0-b4d0-e300d3ff7562', 'web document', 'web description',
--         'web', 'db5adc50-df69-4bd0-b4d0-e300d3ff7560');
--
-- insert into text_document (id, document_id, text_content, text_content_hash)
-- values ('4c3a1539-df81-4817-a224-05158ce6fd3a', 'fb5adc50-df69-4bd0-b4d0-e300d3ff7560',
--         'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a documents or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design. Lorem ipsum is typically a corrupted version of De finibus bonorum et malorum, a 1st-century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin. Versions of the Lorem ipsum text have been used in typesetting at least since the 1960s, when it was popularized by advertisements for Letraset transfer sheets.[1] Lorem ipsum was introduced to the digital world in the mid-1980s, when Aldus employed it in graphic and word-processing templates for its desktop publishing program PageMaker. Other popular word processors, including Pages and Microsoft Word, have since adopted Lorem ipsum,[2] as have many LaTeX packages,[3][4][5] web content managers such as Joomla! and WordPress, and CSS libraries such as Semantic UI.[6]',
--         '4ea4b8156eb7a070adcbee3ff8186b8c78de8c0d9e93d4fe6272b3d4534e4ca9');
-- insert into file_document (id, document_id, file_name, file_data_hash)
-- values ('4c3a1539-df81-4817-a224-05158ce6fd3b', 'fb5adc50-df69-4bd0-b4d0-e300d3ff7561.txt',
--         '4ea4b8156eb7a070adcbee3ff8186b8c78de8c0d9e93d4fe6272b3d4534e4ca9');
-- insert into web_document (id, document_id, web_url, web_url_hash)
-- values ('4c3a1539-df81-4817-a224-05158ce6fd3c', 'fb5adc50-df69-4bd0-b4d0-e300d3ff7562', 'https://www.google.com',
--         'ac6bb669e40e44a8d9f8f0c94dfc63734049dcf6219aac77f02edf94b9162c09');
--
-- -- populate table document_processes from web documents to file documents
-- insert into document_process (id, initial_document_id, final_document_id, started_at, finished_at)
-- values ('63624e7e-a1bd-418f-a97d-241490240f1a', 'fb5adc50-df69-4bd0-b4d0-e300d3ff7562',
--         'fb5adc50-df69-4bd0-b4d0-e300d3ff7561', now()::timestamptz, now()::timestamptz);


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
from file_document fd;

select *
from document_process dp
where dp.id = '9bff7f89-86de-4a4f-8e41-648b7756d917';