$tables = {
	"tables" => {
		"Company" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "user_id", "type" => "int"},
				{"name" => "date_updated", "type" => "datetime"}
			]
		},
		"File" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "object_class", "type" => "varchar"},
				{"name" => "object_id", "type" => "int"},
				{"name" => "filename", "type" => "varchar"},
				{"name" => "filesize", "type" => "bigint"},
				{"name" => "filetype", "type" => "varchar"}
			],
			"renames" => ["Files"]
		},
		"Link" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "object_from_class", "type" => "varchar"},
				{"name" => "object_from_id", "type" => "int"},
				{"name" => "object_to_class", "type" => "varchar"},
				{"name" => "object_to_id", "type" => "int"},
				{"name" => "date_added", "type" => "datetime"},
				{"name" => "added_user_id", "type" => "int"}
			],
			"indexes" => [
				{"name" => "object_from_lookup", "columns" => ["object_from_class", "object_from_id"]},
				{"name" => "object_to_lookup", "columns" => ["object_to_class", "object_to_id"]},
				{"name" => "added_user_id", "columns" => ["added_user_id"]}
			]
		},
		"Log" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "message", "type" => "text"},
				{"name" => "date", "type" => "datetime"},
				{"name" => "get", "type" => "text"},
				{"name" => "post", "type" => "text"},
				{"name" => "meta", "type" => "text"}
			],
			"indexes" => [
				
			]
		},
		"Log_link" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "log_id", "type" => "int"},
				{"name" => "object_class", "type" => "varchar"},
				{"name" => "object_id", "type" => "int"}
			],
			"indexes" => [
				{"name" => "object_lookup", "columns" => ["object_class", "object_id"]}
			]
		},
		"Page" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "id_str", "type" => "varchar", "maxlength" => 255},
				{"name" => "date_added", "type" => "datetime"},
				{"name" => "added_user_id", "type" => "int"}
			],
			"indexes" => [
				{"name" => "id_str", "columns" => ["id_str"]},
				{"name" => "added_user_id", "columns" => ["added_user_id"]}
			]
		},
		"Points" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "object_class", "type" => "varchar"},
				{"name" => "object_id", "type" => "int"},
				{"name" => "user_id", "type" => "int"},
				{"name" => "points", "type" => "decimal", "maxlength" => "10,2"},
				{"name" => "date_saved", "type" => "datetime"}
			],
			"indexes" => [
				{"name" => "object_lookup", "columns" => ["object_class", "object_id"]},
				{"name" => "user_id", "columns" => ["user_id"]}
			],
			"columns_remove" => {
				"company_id" => true
			}
		},
		"Product" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "date_added", "type" => "datetime"}
			]
		},
		"User" => {
			"columns" => [
				{"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
				{"name" => "username", "type" => "varchar"},
				{"name" => "password", "type" => "varchar"}
			],
			"on_create_after" => proc{|data|
				data["db"].insert("User", {
					"username" => "admin",
					"password" => Knj::Php.md5("admin")
				})
			}
		}
	}
}