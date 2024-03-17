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
    initial_document_id uuid        not null references document (id) on delete cascade on update cascade,
    final_document_id   uuid        not null references document (id) on delete cascade on update cascade,
    started_at          timestamptz not null,
    finished_at         timestamptz not null,
    constraint initial_and_final_document_id_different_check check (initial_document_id != final_document_id)
);


drop table if exists file_document cascade;
create table file_document
(
    id             uuid primary key not null references document (id) on delete cascade on update cascade,
    file_name      text             not null,
    file_extension text             not null,
    file_data      bytea            not null,
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
-- insert into file_document (id, document_id, file_name, file_extension, file_data, file_data_hash)
-- values ('4c3a1539-df81-4817-a224-05158ce6fd3b', 'fb5adc50-df69-4bd0-b4d0-e300d3ff7561', 'file', 'txt',
--         decode(
--                 '496e207075626c697368696e6720616e6420677261706869632064657369676e2c204c6f72656d20697073756d206973206120706c616365686f6c646572207465787420636f6d6d6f6e6c79207573656420746f2064656d6f6e737472617465207468652076697375616c20666f726d206f66206120646f63756d656e7473206f72206120747970656661636520776974686f75742072656c79696e67206f6e206d65616e696e6766756c20636f6e74656e742e204c6f72656d20697073756d206d61792062652075736564206173206120706c616365686f6c646572206265666f72652066696e616c20636f707920697320617661696c61626c652e20497420697320616c736f207573656420746f2074656d706f726172696c79207265706c616365207465787420696e20612070726f636573732063616c6c656420677265656b696e672c20776869636820616c6c6f77732064657369676e65727320746f20636f6e73696465722074686520666f726d206f6620612077656270616765206f72207075626c69636174696f6e2c20776974686f757420746865206d65616e696e67206f6620746865207465787420696e666c75656e63696e67207468652064657369676e2e204c6f72656d20697073756d206973207479706963616c6c79206120636f727275707465642076657273696f6e206f662044652066696e6962757320626f6e6f72756d206574206d616c6f72756d2c2061203173742d63656e7475727920424320746578742062792074686520526f6d616e207374617465736d616e20616e64207068696c6f736f706865722043696365726f2c207769746820776f72647320616c74657265642c2061646465642c20616e642072656d6f76656420746f206d616b65206974206e6f6e73656e736963616c20616e6420696d70726f706572204c6174696e2e2056657273696f6e73206f6620746865204c6f72656d20697073756d20746578742068617665206265656e207573656420696e207479706573657474696e67206174206c656173742073696e6365207468652031393630732c207768656e2069742077617320706f70756c6172697a6564206279206164766572746973656d656e747320666f72204c65747261736574207472616e73666572207368656574732e5b315d204c6f72656d20697073756d2077617320696e74726f647563656420746f20746865206469676974616c20776f726c6420696e20746865206d69642d31393830732c207768656e20416c64757320656d706c6f79656420697420696e206772617068696320616e6420776f72642d70726f63657373696e672074656d706c6174657320666f7220697473206465736b746f70207075626c697368696e672070726f6772616d20506167654d616b65722e204f7468657220706f70756c617220776f72642070726f636573736f72732c20696e636c7564696e6720506167657320616e64204d6963726f736f667420576f72642c20686176652073696e63652061646f70746564204c6f72656d20697073756d2c5b325d2061732068617665206d616e79204c61546558207061636b616765732c5b335d5b345d5b355d2077656220636f6e74656e74206d616e61676572732073756368206173204a6f6f6d6c612120616e6420576f726450726573732c20616e6420435353206c696272617269657320737563682061732053656d616e7469632055492e5b365d',
--                 'hex'
--         ),
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

select encode(fd.file_data, 'hex'),
       encode(fd.file_data, 'escape'),
       *
from file_document fd;

select *
from file_document fd;
