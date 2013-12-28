package com.eryansky.codegen.util;

/**
 * 各类资源配置
 */
public class Resources {

	/************ 数据库配置 ************/
	public static final String DRIVER = "org.gjt.mm.mysql.Driver";
	public static final String URL = "jdbc:mysql://localhost/essh?useUnicode=true&characterEncoding=UTF-8"; // 数据库访问串
	public static final String USERNAME = "root";
	public static final String PASSWORD = "root";

//    public static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
//    public static final String URL = "jdbc:oracle:thin:@192.168.2.234:1521:orcl"; // 数据库访问串
//    public static final String USERNAME = "essh";
//    public static final String PASSWORD = "password";
	

	
	public static final String CATALOG = "";
	public static final String SCHEMA = "ESSH";

    /**
     * 模块名称
     */
    public static final String MODULE = "sys";
	

	/************ 模板配置 ************/
	public static final String TEMPLATE_PATH = "codegen/template";
	public static final String ENTITY_TEMPLATE = "java_entity.vm";
	public static final String SERVICE_TEMPLATE = "java_service.vm";
	public static final String CONTROLLER_TEMPLATE = "java_controller.vm";

	public static final String JSP_LIST_TEMPLATE = "jsp_list.vm";
	public static final String JSP_INPUT_TEMPLATE = "jsp_input.vm";

	/************
	 * Package 声明,
	 * 如果只声明了BASE_PACKAGE,未声明其它Package
	 * 那么以base_package为基础创建目录/com/**
	 * -entity
	 * -dao
	 * -service
	 * --impl
	 * -controller
	 **************/



	public static final String BASE_PACKAGE = "com.eryansky";
	public static final String ENTITY_PACKAGE = "com.eryansky.entity"+"."+MODULE;
	public static final String SERVICE_PACKAGE = "com.eryansky.service"+"."+MODULE;
	public static final String CONTROLLER_PACKAGE = "com.eryansky.web"+"."+MODULE;

	/************ controller访问地址 : request_mapping/moudle ****************/
	public static final String REQUEST_MAPPING = "jsp/"+MODULE;

	/************ JSP文件存储地址 ****************/
	public static final String JSP_STORE_PATH =  "C:\\Users\\Administrator\\Desktop\\code_genner\\view\\";
	/************ 生成JAVA文件的根目录，系统根据package声明进行目录创建 **********/
	public static final String JAVA_STROE_PATH = "C:\\Users\\Administrator\\Desktop\\code_genner\\java\\";

	public static String getClazzNameByTableName(String tableName) {
		return null;
	}

	/**
	 * 根据Java文件类型获取存储地址
	 * 
	 * @param type
	 * @return
	 */
	public static String getJavaStorePath(FileType type) {
		String packageDecl = getPackage(type);
		packageDecl = packageDecl.replaceAll("\\.", "/");
		return JAVA_STROE_PATH + "/" + packageDecl;
	}

	/**
	 * 根据Java文件类型获取Package声明
	 * 
	 * @param type
	 * @return
	 */
	public static String getPackage(FileType type) {
		if (type.getPakage() == null || "".equals(type.getPakage()))
			return BASE_PACKAGE + "." + type.getType();
		else
			return type.getPakage();
	}

}
