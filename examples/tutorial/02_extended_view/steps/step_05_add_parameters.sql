CREATE OR REPLACE PACKAGE extended_view AUTHID CURRENT_USER AS
   -- oddgen PL/SQL data types
   SUBTYPE string_type IS VARCHAR2(1000 CHAR);
   TYPE t_string IS TABLE OF string_type;
   SUBTYPE param_type IS VARCHAR2(30 CHAR);
   TYPE t_param IS TABLE OF string_type INDEX BY param_type;

   FUNCTION get_name RETURN VARCHAR2;

   FUNCTION get_description RETURN VARCHAR2;
   
   FUNCTION get_object_types RETURN t_string;

   FUNCTION get_object_names(in_object_type IN VARCHAR2) RETURN t_string;

   FUNCTION get_params (
      in_object_type IN VARCHAR2, 
      in_object_name IN VARCHAR2
   ) RETURN t_param;

   FUNCTION generate (
      in_object_type IN VARCHAR2,
      in_object_name IN VARCHAR2
   ) RETURN CLOB;
END extended_view;
/

CREATE OR REPLACE PACKAGE BODY extended_view AS
   -- parameter constants, used as labels in the generate dialog
   co_select_star   CONSTANT string_type := 'Select * ?';
   co_view_suffix   CONSTANT string_type := 'View suffix';
   co_order_columns CONSTANT string_type := 'Order columns?';

   FUNCTION get_name RETURN VARCHAR2 IS
   BEGIN
      RETURN 'Extended 1:1 View Generator';
   END get_name;

   FUNCTION get_description RETURN VARCHAR2 IS
   BEGIN
      RETURN 'Generates a 1:1 view based on an existing ' || 
         'table and various generator parameters.';
   END get_description;

   FUNCTION get_object_types RETURN t_string IS
   BEGIN
      RETURN NEW t_string('TABLE');
   END get_object_types;

   FUNCTION get_object_names(in_object_type IN VARCHAR2) RETURN t_string IS
      l_object_names t_string;
   BEGIN
      SELECT initcap(object_name) AS object_name
        BULK COLLECT
        INTO l_object_names
        FROM user_objects
       WHERE object_type = in_object_type
             AND generated = 'N'
       ORDER BY object_name;
      RETURN l_object_names;
   END get_object_names;

   FUNCTION get_params (
      in_object_type IN VARCHAR2, 
      in_object_name IN VARCHAR2
   ) RETURN t_param IS
      l_params t_param;
   BEGIN
      l_params(co_select_star) := 'No';
      l_params(co_view_suffix) := '_v';
      l_params(co_order_columns) := 'No';
      RETURN l_params;
   END get_params;

   FUNCTION generate (
      in_object_type IN VARCHAR2,
      in_object_name IN VARCHAR2
   ) RETURN CLOB IS
      l_templ        CLOB := 
'CREATE OR REPLACE VIEW ${view_name} AS
   SELECT ${column_names}
     FROM ${table_name};';
      l_clob         CLOB;
      l_view_name    string_type;
      l_column_names string_type;
      l_table_name   string_type;
   BEGIN
      -- prepare placeholders
      l_column_names := '*';
      l_table_name := lower(in_object_name);
      l_view_name := l_table_name || '_v';
      -- produce final clob, replace placeholder in template
      l_clob := REPLACE(l_templ, '${column_names}', l_column_names);
      l_clob := REPLACE(l_clob, '${view_name}', l_view_name);
      l_clob := REPLACE(l_clob, '${table_name}', l_table_name);
      RETURN l_clob;
   END generate;
END extended_view;
/