CREATE OR REPLACE PACKAGE oddgen_interface_example AUTHID CURRENT_USER IS
   /*
   * Copyright 2015-2016 Philipp Salvisberg <philipp.salvisberg@trivadis.com>
   *
   * Licensed under the Apache License, Version 2.0 (the "License");
   * you may not use this file except in compliance with the License.
   * You may obtain a copy of the License at
   *
   *     http://www.apache.org/licenses/LICENSE-2.0
   *
   * Unless required by applicable law or agreed to in writing, software
   * distributed under the License is distributed on an "AS IS" BASIS,
   * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   * See the License for the specific language governing permissions and
   * limitations under the License.
   */

   /** 
   * oddgen PL/SQL database server generator.
   * complete interface example. 
   * PL/SQL package specification only. 
   * PL/SQL package body is not part of the interface definition.
   *
   * @headcom
   */

   /**
   * oddgen PL/SQL data types
   */
   SUBTYPE string_type IS VARCHAR2(1000 CHAR);
   SUBTYPE param_type IS VARCHAR2(30 CHAR);
   TYPE t_string IS TABLE OF string_type;
   TYPE t_param IS TABLE OF string_type INDEX BY param_type;
   TYPE t_lov IS TABLE OF t_string INDEX BY param_type;

   /**
   * Get name of the generator, used in tree view
   * If this function is not implemented, the package name will be used.
   *
   * @returns name of the generator
   *
   * @since v0.1
   */
   FUNCTION get_name RETURN VARCHAR2;

   /**
   * Get the description of the generator.
   * If this function is not implemented, the owner and the package name will be used.
   * 
   * @returns description of the generator
   *
   * @since v0.1
   */
   FUNCTION get_description RETURN VARCHAR2;

   /**
   * Get the list of supported object types.
   * If this function is not implemented, [TABLE, VIEW] will be used. 
   *
   * @returns a list of supported object types
   *
   * @since v0.1
   */
   FUNCTION get_object_types RETURN t_string;

   /**
   * Get the list of objects for a object type.
   * If this function is not implemented, the result of the following query will be used:
   * "SELECT object_name FROM user_objects WHERE object_type = in_object_type"
   *
   * @param in_object_type object type to filter objects
   * @returns a list of objects
   *
   * @since v0.1
   */
   FUNCTION get_object_names(in_object_type IN VARCHAR2) RETURN t_string;

   /**
   * Get all parameters supported by the generator including default values.
   * If this function is not implemented, no parameters will be used.
   *
   * @returns parameters supported by the generator
   *
   * @since v0.1
   */
   FUNCTION get_params RETURN t_param;

   /**
   * Get the list of values per parameter, if such a LOV is applicable.
   * If this function is not implemented, then the parameters cannot be validated in the GUI.
   *
   * @returns parameters with their list-of-values
   *
   * @since v0.1
   */
   FUNCTION get_lov RETURN t_lov;

   /**
   * Updates the list of values per parameter.
   * This function is called after a parameter change in the GUI.
   * Do not implement this function, unless you really need it.
   *
   * @param in_object_type object type to process
   * @param in_object_name object_name of in_object_type to process
   * @param in_params parameters to configure the behavior of the generator
   * @returns parameters with their list-of-values
   *
   * @since v0.1
   */
   FUNCTION refresh_lov(in_object_type IN VARCHAR2,
                        in_object_name IN VARCHAR2,
                        in_params      IN t_param) RETURN t_lov;

   /**
   * Sets/updates the editable state of a parameter. 
   * This function is called after a parameter change in the GUI.
   * Call this function to enable/disable a parameter based on other values.
   * Parameters with a assigned list-of-values are enabled/disabled automatically.
   * If this function is not implemented, all parameters are enabled.
   * Do not implement this function, unless you really need it.
   *
   * @param in_params parameters to configure the behavior of the generator
   * @returns parameters with their editable state ("0"=disabled, "1"=enabled)
   *
   * @since v0.2
   */
   FUNCTION refresh_param_states(in_params IN t_param) RETURN t_param;

   /**
   * Generates the result.
   * Complete signature. 
   * Either this signature or the simplified signature or both must be implemented.
   *
   * @param in_object_type object type to process
   * @param in_object_name object_name of in_object_type to process
   * @param in_params parameters to configure the behavior of the generator
   * @returns generator output
   *
   * @since v0.1
   */
   FUNCTION generate(in_object_type IN VARCHAR2,
                     in_object_name IN VARCHAR2,
                     in_params      IN t_param) RETURN CLOB;

   /**
   * Generate the result.  
   * Simplified signature, which is applicable in SQL. 
   * Either this signature or the complete signature or both must be implemented.
   *
   * @param in_object_type object type to process
   * @param in_object_name object_name of in_object_type to process
   * @returns generator output
   *
   * @since v0.1
   */
   FUNCTION generate(in_object_type IN VARCHAR2, in_object_name IN VARCHAR2) RETURN CLOB;
END oddgen_interface_example;
/
