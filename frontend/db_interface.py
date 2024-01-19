import mysql.connector
from prettytable import PrettyTable
from getpass import getpass

def get_all_table_names(connection):
    cursor = connection.cursor()
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()
    table_names = [table[0] for table in tables]
    cursor.close()
    return table_names
 
def get_foreign_keys(connection, table_name, schema_name, processed_tables=None, depth=0, max_depth=5):
    if processed_tables is None:
        processed_tables = set()

    if depth > max_depth or table_name in processed_tables:
        return 

    processed_tables.add(table_name)

    cursor = connection.cursor()
    cursor.execute("""
        SELECT 
            TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
        FROM
            INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE
            REFERENCED_TABLE_SCHEMA = %s AND
            TABLE_NAME = %s;
    """, (schema_name, table_name,))

    fks = cursor.fetchall()
    cursor.close()

    if not fks:
        print("  " * depth + f"No foreign keys found for table '{table_name}'")
        return

    for fk in fks:
        table, column, constraint, ref_table, ref_column = fk
        print("  " * depth + f"Table '{table}', Column '{column}', Constraint '{constraint}' references '{ref_table}({ref_column})'")
        
        get_foreign_keys(connection, ref_table, schema_name, processed_tables, depth + 1, max_depth)

def delete_data(connection):
    table_names = get_all_table_names(connection)
    for i, table in enumerate(table_names, 1):
        print(f"{i}. {table}")
    
    table_choice = int(input("Select a table to delete from (enter number): ")) - 1
    selected_table = table_names[table_choice]

    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM {selected_table}")
    rows = cursor.fetchall()
    field_names = [i[0] for i in cursor.description]

    from prettytable import PrettyTable
    table = PrettyTable(field_names)
    for row in rows:
        table.add_row(row)
    print(table)

    id_to_delete = input(f"Enter the ID of the record to delete from '{selected_table}': ")
    delete_query = f"DELETE FROM {selected_table} WHERE {field_names[0]} = %s"
    try:
        cursor.execute(delete_query, (id_to_delete,))
        connection.commit()
        print("Record deleted successfully.")
    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
def get_all_view_names(connection):
    cursor = connection.cursor()
    try:
        cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = SCHEMA()")
        views = cursor.fetchall()
        return [view[0] for view in views]
    except mysql.connector.Error as e:
        print(f"Error fetching views: {e}")
    finally:
        cursor.close()

def see_reports(connection):
    view_names = get_all_view_names(connection)
    if not view_names:
        print("No views found or unable to fetch views.")
        return

    for i, view in enumerate(view_names, 1):
        print(f"{i}. {view}")
    
    try:
        view_choice = int(input("Select a view to display (enter number): ")) - 1
        selected_view = view_names[view_choice]

        cursor = connection.cursor()
        cursor.execute(f"SELECT * FROM {selected_view}")
        rows = cursor.fetchall()
        field_names = [i[0] for i in cursor.description]

        from prettytable import PrettyTable
        table = PrettyTable(field_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except IndexError:
        print("Invalid selection. Please enter a valid number.")
    except mysql.connector.Error as e:
        print(f"Error displaying view data: {e}")
    finally:
        cursor.close()
    
allowed_tables = ['sense', 'languages', 'movement', 'damage_type_relationship', 'condition_relationship']
def get_table_structure(connection, table_name):
    cursor = connection.cursor()
    cursor.execute("SHOW FULL COLUMNS FROM `{}`".format(table_name))
    structure = cursor.fetchall()
    cursor.close()
    return structure
def show_enum_values(connection, table_name, column_name):
    cursor = connection.cursor()
    try:
        cursor.execute("SHOW COLUMNS FROM `{}` LIKE %s".format(table_name), (column_name,))
        result = cursor.fetchone()
        type_detail = result[1]

        if isinstance(type_detail, bytes):
            type_detail = type_detail.decode('utf-8')

        if "enum" in type_detail:
            enum_values = type_detail[type_detail.find("(")+1:type_detail.find(")")].replace("'", "")
            return enum_values.split(',')
        else:
            return []
    except Exception as e:
        print(f"Error retrieving enum values: {e}")
    finally:
        cursor.close()
def show_foreign_key_references(connection, fk_table):
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM {fk_table}")
    rows = cursor.fetchall()
    for row in rows:
        print(row)
def add_data(connection):
    print("Select a table to add data:")
    for i, table in enumerate(allowed_tables, 1):
        print(f"{i}. {table}")
    table_choice = int(input("Enter your choice: ")) - 1
    selected_table = allowed_tables[table_choice]

    table_structure = get_table_structure(connection, selected_table)
    data_to_insert = []

    for column in table_structure:
        col_name, col_type = column[:2]  

        col_type = col_type.decode('utf-8') if isinstance(col_type, bytes) else col_type

        if "enum" in col_type:
            enum_values = show_enum_values(connection, selected_table, col_name)
            print(f"Choose a value for {col_name} {enum_values}: ")
            value = input()
            while value not in enum_values:
                print("Invalid input. Please choose a valid value.")
                value = input()
        elif "int" in col_type:
            cursor = connection.cursor()
            cursor.execute(f"SHOW COLUMNS FROM {selected_table} WHERE Field = %s", (col_name,))
            col_details = cursor.fetchone()
            if 'auto_increment' in col_details[5]:
                continue  
            print(f"Enter a value for {col_name} (integer expected): ")
            value = input()
            while not value.isdigit():
                print("Invalid input. Please enter a valid integer.")
                value = input()
            value = int(value)
        else:
            print(f"Enter a value for {col_name}: ")
            value = input()

        data_to_insert.append(value)

    insert_columns = [col[0] for col in table_structure if 'auto_increment' not in col[6]]
    placeholders = ', '.join(['%s'] * len(insert_columns))
    insert_query = f"INSERT INTO {selected_table} ({', '.join(insert_columns)}) VALUES ({placeholders})"
    cursor = connection.cursor()
    try:
        cursor.execute(insert_query, tuple(data_to_insert))
        connection.commit()
        print("Data added successfully.")
    except mysql.connector.Error as e:
        print(f"Error adding data: {e}")
    finally:
        cursor.close()



def show_admin_menu(connection):
    while True:
        print("-"*18)
        print("\nDatabase Management Menu")
        print("1. Add Data")
        print("2. Delete Data")
        print("3. Change Data")
        print("4. See Reports")
        print("5. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':            
            add_data(connection)
        elif choice == '2':
            delete_data(connection)
        elif choice == '3':
            change_data(connection)
        elif choice == '4':
            see_reports(connection)
        elif choice == '5':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

def change_data(connection):
    table_names = get_all_table_names(connection)
    for i, table in enumerate(table_names, 1):
        print(f"{i}. {table}")
    
    table_choice = int(input("Select a table to modify (enter number): ")) - 1
    selected_table = table_names[table_choice]

    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM {selected_table}")
    rows = cursor.fetchall()
    field_names = [i[0] for i in cursor.description]

    from prettytable import PrettyTable
    table = PrettyTable(field_names)
    for row in rows:
        table.add_row(row)
    print(table)

    id_to_modify = input(f"Enter the ID of the record to modify in '{selected_table}': ")

    for i, field in enumerate(field_names, 1):
        print(f"{i}. {field}")

    column_choice = int(input("Select a column to modify (enter number): ")) - 1
    selected_column = field_names[column_choice]
    new_value = input(f"Enter the new value for '{selected_column}': ")

    update_query = f"UPDATE {selected_table} SET {selected_column} = %s WHERE {field_names[0]} = %s"
    try:
        cursor.execute(update_query, (new_value, id_to_modify))
        connection.commit()
        print("Record updated successfully.")
    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        cursor.close()

def login_to_database():
    host = input("Enter database host ip (e.g., 'localhost'): ")
    user = input("Enter your username: ")
    password = getpass("Enter your password: ") 
    database = "game_studio" 

    try:
        connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database
        )
        print("Login successful!")
        return connection
    except mysql.connector.Error as e:
        print(f"Error: {e}")
        return None
    
def main():
    connection = login_to_database()
    while not connection:
        connection = login_to_database()

    user_permission_level = 'admin' 

    if user_permission_level == 'admin':
        show_admin_menu(connection)

    elif user_permission_level == 'dm':
        pass 

    elif user_permission_level == 'user':
        pass
    else:
        print("Unknown permission level.")

if __name__ == "__main__":
    main()
