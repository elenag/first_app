CREATE TABLE "accounts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "acc_number" varchar(255), "school_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "homeroom_id" integer, "status" varchar(255), "number_broken" integer, "flagged" boolean, "comments" text);
CREATE TABLE "active_admin_comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "resource_id" varchar(255) NOT NULL, "resource_type" varchar(255) NOT NULL, "author_id" integer, "author_type" varchar(255), "body" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "namespace" varchar(255));
CREATE TABLE "admin_users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "can_edit_origins" boolean, "ops_rel" boolean, "publishing_rel" boolean, "DR_rel" boolean);
CREATE TABLE "admin_users_projects" ("admin_user_id" integer, "project_id" integer);
CREATE TABLE "appstatuses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "authors" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "origin_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "comments" text);
CREATE TABLE "authors_books" ("book_id" integer, "author_id" integer);
CREATE TABLE "book_statuses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "books" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "asin" varchar(255), "title" varchar(255), "price" decimal, "rating" integer, "flagged" boolean DEFAULT 'f', "copublished" boolean, "publisher_id" integer, "language_id" integer, "genre_id" integer, "comments" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "date_added" date, "restricted" boolean, "limited" integer, "fiction_type_id" integer, "textbook_level_id" integer, "textbook_subject_id" integer, "book_status_id" integer, "appstatus_id" integer);
CREATE TABLE "books_content_buckets" ("book_id" integer, "content_bucket_id" integer);
CREATE TABLE "books_levels" ("book_id" integer, "level_id" integer);
CREATE TABLE "books_platforms" ("book_id" integer, "platform_id" integer);
CREATE TABLE "books_publishing_rights" ("book_id" integer, "publishing_right_id" integer);
CREATE TABLE "content_buckets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "project_id" integer);
CREATE TABLE "content_buckets_homerooms" ("content_bucket_id" integer, "homeroom_id" integer);
CREATE TABLE "continents" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "device_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "devices" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "serial_number" varchar(255), "flagged" boolean DEFAULT 'f', "control" integer, "reinforced_screen" boolean DEFAULT 'f', "device_type_id" integer, "account_id" integer, "purchase_order_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "status" varchar(255), "return_reason" varchar(255), "comments" text, "action" varchar(255));
CREATE TABLE "events" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "device_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "fiction_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "genres" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "homerooms" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "school_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "languages" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "levels" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "models" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "origins" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "continent_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "platforms" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "project_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "model_id" integer, "origin_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "target_size" integer, "current_size" integer, "comments" text, "admin_user_id" integer, "project_type_id" integer);
CREATE TABLE "publishers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "origin_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "publishing_rights" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "purchase_orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "po_number" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "date_ordered" date, "warranty_end_date" date, "project_id" integer, "comments" text);
CREATE TABLE "pushes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "book_id" integer, "content_bucket_id" integer, "push_date" date, "successful" boolean, "comments" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "schools" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "project_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "students" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "other_names" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "account_id" integer, "comments" text, "role" varchar(255));
CREATE TABLE "textbook_levels" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "textbook_subjects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "admin_user_project_index" ON "admin_users_projects" ("admin_user_id", "project_id");
CREATE UNIQUE INDEX "book_publishing_right_index" ON "books_publishing_rights" ("book_id", "publishing_right_id");
CREATE UNIQUE INDEX "content_bucket_homeroom_index" ON "content_buckets_homerooms" ("content_bucket_id", "homeroom_id");
CREATE INDEX "device_account_po_dt_index" ON "devices" ("account_id", "purchase_order_id", "device_type_id");
CREATE INDEX "index_accounts_on_homeroom_id_and_school_id" ON "accounts" ("homeroom_id", "school_id");
CREATE INDEX "index_active_admin_comments_on_author_type_and_author_id" ON "active_admin_comments" ("author_type", "author_id");
CREATE INDEX "index_active_admin_comments_on_namespace" ON "active_admin_comments" ("namespace");
CREATE INDEX "index_admin_notes_on_resource_type_and_resource_id" ON "active_admin_comments" ("resource_type", "resource_id");
CREATE UNIQUE INDEX "index_admin_users_on_email" ON "admin_users" ("email");
CREATE UNIQUE INDEX "index_admin_users_on_reset_password_token" ON "admin_users" ("reset_password_token");
CREATE INDEX "index_authors_books_on_book_id_and_author_id" ON "authors_books" ("book_id", "author_id");
CREATE INDEX "index_authors_on_origin_id" ON "authors" ("origin_id");
CREATE INDEX "index_books_content_buckets_on_book_id_and_content_bucket_id" ON "books_content_buckets" ("book_id", "content_bucket_id");
CREATE INDEX "index_books_levels_on_book_id_and_level_id" ON "books_levels" ("book_id", "level_id");
CREATE INDEX "index_books_on_book_status_id_and_appstatus_id" ON "books" ("book_status_id", "appstatus_id");
CREATE INDEX "index_books_on_fiction_type_id" ON "books" ("fiction_type_id");
CREATE INDEX "index_books_on_genre_id" ON "books" ("genre_id");
CREATE INDEX "index_books_on_language_id" ON "books" ("language_id");
CREATE INDEX "index_books_on_publisher_id" ON "books" ("publisher_id");
CREATE INDEX "index_books_on_textbook_level_id" ON "books" ("textbook_level_id");
CREATE INDEX "index_books_on_textbook_subject_id" ON "books" ("textbook_subject_id");
CREATE INDEX "index_books_platforms_on_book_id_and_platform_id" ON "books_platforms" ("book_id", "platform_id");
CREATE INDEX "index_events_on_device_id" ON "events" ("device_id");
CREATE INDEX "index_homerooms_on_school_id" ON "homerooms" ("school_id");
CREATE INDEX "index_origins_on_continent_id" ON "origins" ("continent_id");
CREATE INDEX "index_projects_on_origin_id_and_model_id" ON "projects" ("origin_id", "model_id");
CREATE INDEX "index_publishers_on_origin_id" ON "publishers" ("origin_id");
CREATE INDEX "index_pushes_on_book_id_and_content_bucket_id" ON "pushes" ("book_id", "content_bucket_id");
CREATE INDEX "index_schools_on_project_id" ON "schools" ("project_id");
CREATE INDEX "index_students_on_account_id" ON "students" ("account_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120416203522');

INSERT INTO schema_migrations (version) VALUES ('20120416203539');

INSERT INTO schema_migrations (version) VALUES ('20120416203550');

INSERT INTO schema_migrations (version) VALUES ('20120416203619');

INSERT INTO schema_migrations (version) VALUES ('20120416203629');

INSERT INTO schema_migrations (version) VALUES ('20120416203642');

INSERT INTO schema_migrations (version) VALUES ('20120416203650');

INSERT INTO schema_migrations (version) VALUES ('20120416203659');

INSERT INTO schema_migrations (version) VALUES ('20120416203706');

INSERT INTO schema_migrations (version) VALUES ('20120416205746');

INSERT INTO schema_migrations (version) VALUES ('20120416205802');

INSERT INTO schema_migrations (version) VALUES ('20120416205905');

INSERT INTO schema_migrations (version) VALUES ('20120416210035');

INSERT INTO schema_migrations (version) VALUES ('20120416210043');

INSERT INTO schema_migrations (version) VALUES ('20120416210135');

INSERT INTO schema_migrations (version) VALUES ('20120416210220');

INSERT INTO schema_migrations (version) VALUES ('20120416210228');

INSERT INTO schema_migrations (version) VALUES ('20120416211854');

INSERT INTO schema_migrations (version) VALUES ('20120416215152');

INSERT INTO schema_migrations (version) VALUES ('20120419092554');

INSERT INTO schema_migrations (version) VALUES ('20120419101337');

INSERT INTO schema_migrations (version) VALUES ('20120419101354');

INSERT INTO schema_migrations (version) VALUES ('20120419101404');

INSERT INTO schema_migrations (version) VALUES ('20120419103048');

INSERT INTO schema_migrations (version) VALUES ('20120419103838');

INSERT INTO schema_migrations (version) VALUES ('20120420205326');

INSERT INTO schema_migrations (version) VALUES ('20120510104522');

INSERT INTO schema_migrations (version) VALUES ('20120510124525');

INSERT INTO schema_migrations (version) VALUES ('20120510124526');

INSERT INTO schema_migrations (version) VALUES ('20120518101621');

INSERT INTO schema_migrations (version) VALUES ('20120529081639');

INSERT INTO schema_migrations (version) VALUES ('20120529094814');

INSERT INTO schema_migrations (version) VALUES ('20120601020755');

INSERT INTO schema_migrations (version) VALUES ('20120606095931');

INSERT INTO schema_migrations (version) VALUES ('20120608100929');

INSERT INTO schema_migrations (version) VALUES ('20120621140518');

INSERT INTO schema_migrations (version) VALUES ('20120627140743');

INSERT INTO schema_migrations (version) VALUES ('20120628095819');

INSERT INTO schema_migrations (version) VALUES ('20120628100125');

INSERT INTO schema_migrations (version) VALUES ('20120628100722');

INSERT INTO schema_migrations (version) VALUES ('20120628101015');

INSERT INTO schema_migrations (version) VALUES ('20120702164143');

INSERT INTO schema_migrations (version) VALUES ('20120704211356');

INSERT INTO schema_migrations (version) VALUES ('20120711200855');

INSERT INTO schema_migrations (version) VALUES ('20120711201247');

INSERT INTO schema_migrations (version) VALUES ('20120725125946');

INSERT INTO schema_migrations (version) VALUES ('20120725130230');

INSERT INTO schema_migrations (version) VALUES ('20120726122700');

INSERT INTO schema_migrations (version) VALUES ('20120802165631');

INSERT INTO schema_migrations (version) VALUES ('20120824114943');

INSERT INTO schema_migrations (version) VALUES ('20120831062211');

INSERT INTO schema_migrations (version) VALUES ('20120831202550');

INSERT INTO schema_migrations (version) VALUES ('20120831202931');

INSERT INTO schema_migrations (version) VALUES ('20120831202943');

INSERT INTO schema_migrations (version) VALUES ('20120831203353');

INSERT INTO schema_migrations (version) VALUES ('20120901194442');

INSERT INTO schema_migrations (version) VALUES ('20120901194500');

INSERT INTO schema_migrations (version) VALUES ('20120901194551');

INSERT INTO schema_migrations (version) VALUES ('20120902195721');

INSERT INTO schema_migrations (version) VALUES ('20120907155712');

INSERT INTO schema_migrations (version) VALUES ('20120907161855');