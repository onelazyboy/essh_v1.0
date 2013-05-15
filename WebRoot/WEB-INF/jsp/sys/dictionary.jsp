<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<script type="text/javascript">
var dictionary_datagrid;
var editRow = undefined;
var editRowData = undefined;
var dictionary_search_form;
var dictionaryTypeCode = undefined;
var dictionary_filter_EQS_dictionaryType__code;
$(function() {  
	dictionary_search_form = $('#dictionary_search_form').form();
    //数据列表
    dictionary_datagrid = $('#dictionary_datagrid').datagrid({  
	    url:'${ctx}/sys/dictionary!datagrid.action',  
	    pagination:true,//底部分页
	    pagePosition:'bottom',//'top','bottom','both'.
	    fitColumns:true,//自适应列宽
	    striped:true,//显示条纹
	    pageSize:20,//每页记录数
	    singleSelect:false,//单选模式
	    rownumbers:true,//显示行数
	    checkbox:true,
		nowrap : false,
		border : false,
		sortName:'orderNo',//默认排序字段
		sortOrder:'asc',//默认排序方式 'desc' 'asc'
		idField : 'id',
		fitColumns:false,//自适应宽度
		columns:[ [ {
				field : 'ck',
				checkbox : true,
				width : 60
			}, {
				field : 'id',
				title : '主键',
				hidden : true,
				sortable:true,
				align : 'right',
				width : 80
			},{
				field : 'dictionaryTypeCode',
				title : '字典类型',
				width : 150,
				formatter : function(value, rowData, rowIndex) {
					if (rowData.dictionaryTypeName) {
						return eu.fs('<span title="{0}">{1}</span>', rowData.dictionaryTypeName, rowData.dictionaryTypeName);
					}
				},
				editor : {
					type : 'combobox',
					options : {
						url:'${ctx}/sys/dictionary-type!combobox.action',
						required : true,
						missingMessage:'请选择字典类型(如果不存在,可以选择新增字典类型)！',
						editable:false,//是否可编辑
						valueField:'value',
				        displayField:'text',
				        onSelect:function(record){
				        	dictionaryTypeCode = record.value;
							var dictionaryTypeEditor = dictionary_datagrid.datagrid('getEditor',{index:editRow,field:'parentDictionaryCode'});
							$(dictionaryTypeEditor.target).combotree('clear').combotree('reload');
							var codeEditor = dictionary_datagrid.datagrid('getEditor',{index:editRow,field:'code'});
							$(codeEditor.target).val(dictionaryTypeCode);
							$(codeEditor.target).validatebox('validate');
				        }
					}
				}
			},{
				field : 'parentDictionaryCode',
				title : '上级节点',
				width : 150,
				formatter : function(value, rowData, rowIndex) {
				    return rowData.parentDictionaryName;
				},
				editor : {
					type : 'combotree',
					options : {
						url:'${ctx}/sys/dictionary!combotree.action?selectType=select',
				        onBeforeLoad:function(node,param){
				        	if(dictionaryTypeCode != undefined){
							    param.dictionaryTypeCode = dictionaryTypeCode; 
				        	}
				        	if(editRowData != undefined){
				        		param.id = editRowData.id;
				        	}
				        }
					}
				}
			}, {
				field : 'name',
				title : '名称',
				width : 260,
				editor : {
					type : 'validatebox',
					options : {
						required : true,
						missingMessage:'请输入名称！',
						validType:['minLength[1]','legalInput']
					}
				}
			}, {
				field : 'code',
				title : '编码',
				align : 'right',
				width : 100,
				sortable:true,
				editor : {
					type : 'validatebox',
					options : {
						required : true,
						missingMessage:'请输入编码！',
						validType:['minLength[1]','legalInput']
					}
				}
			}, {
				field : 'remark',
				title : '备注',
				width : 200,
				editor : {
					type : 'text',
					options : {
					}
				}
			}, {
				field : 'orderNo',
				title : '排序',
				align : 'right',
				width : 80,
				sortable:true,
				editor : {
					type : 'numberspinner',
					options : {
						required : true
					}
				}
			} ] ],
			onDblClickRow : function(rowIndex, rowData) {
				if (editRow != undefined) {
					showMsg("请先保存正在编辑的数据！");
					//dictionary_datagrid.datagrid('endEdit', editRow);
				}else{
					$(this).datagrid('beginEdit', rowIndex);
					$(this).datagrid('unselectAll');
				}
			},
			onBeforeEdit:function(rowIndex, rowData) {
				editRow = rowIndex;
				editRowData = rowData;
				dictionaryTypeCode = rowData.dictionaryTypeCode;
			},
			onAfterEdit : function(rowIndex, rowData, changes) {
				var inserted = dictionary_datagrid.datagrid('getChanges', 'inserted');
				var updated = dictionary_datagrid.datagrid('getChanges', 'updated');
				if (inserted.length < 1 && updated.length < 1) {
					editRow = undefined;
					editRowData = undefined;
					$(this).datagrid('unselectAll');
					return;
				}
				$.post('${ctx}/sys/dictionary!save.action',rowData,
						function(data) {
					if (data.code == 1) {
						dictionary_datagrid.datagrid('acceptChanges');
						cancelSelect();
						dictionary_datagrid.datagrid('reload');
						showMsg(data.msg);
					}else{// 警告信息
						$.messager.alert('提示信息！', data.msg, 'warning',function(){
							dictionary_datagrid.datagrid('beginEdit', editRow);
							if(data.obj){//校验失败字段 获取焦点
								var validateEdit = dictionary_datagrid.datagrid('getEditor',{index:rowIndex,field:data.obj});
								$(validateEdit.target).focus();
							}
						});
					}
			    }, 'json');
			},
			onLoadSuccess:function(){
				$(this).datagrid('clearSelections');//取消所有的已选择项
		    	$(this).datagrid('unselectAll');//取消全选按钮为全选状态
				editRow = undefined;
				editRowData = undefined;
				dictionaryTypeCode = undefined;
			},
			onRowContextMenu : function(e, rowIndex, rowData) {
				e.preventDefault();
				$(this).datagrid('unselectAll');
				$(this).datagrid('selectRow', rowIndex);
				$('#dictionary_menu').menu('show', {
					left : e.pageX,
					top : e.pageY
				});
			}
		});

    dictionary_filter_EQS_dictionaryType__code = $('#filter_EQS_dictionaryType__code').combobox({
    	url:'${ctx}/sys/dictionary-type!combobox.action?selectType=all',
	    multiple:false,//是否可多选
	    editable:false,//是否可编辑
	    width:120,
        valueField:'value',
        displayField:'text'
    });
});
	//设置排序默认值
	function setSortValue(target) {
		$.get('${ctx}/sys/dictionary!maxSort.action', function(data) {
			if (data.code == 1) {
				$(target).numberbox({value:data.obj + 1});
				$(target).numberbox('validate');
			}
		}, 'json');
	}

	//新增
	function add() {
		if (editRow != undefined) {
			showMsg("请先保存正在编辑的数据！");
			//结束编辑 自动保存
			//dictionary_datagrid.datagrid('endEdit', editRow);
		}else{
			cancelSelect();
			var row = {id : ''}; 
			dictionary_datagrid.datagrid('appendRow', row);
			editRow = dictionary_datagrid.datagrid('getRows').length - 1;
			dictionary_datagrid.datagrid('selectRow', editRow);
			dictionary_datagrid.datagrid('beginEdit', editRow);
			var rowIndex = dictionary_datagrid.datagrid('getRowIndex',row);//返回指定行的索引
			var sortEdit = dictionary_datagrid.datagrid('getEditor',{index:rowIndex,field:'orderNo'});
			setSortValue(sortEdit.target);
		}
	}

	//编辑
	function edit() {
		//选中的所有行
		var rows = dictionary_datagrid.datagrid('getSelections');
		//选中的行（第一条）
		var row = dictionary_datagrid.datagrid('getSelected');
		if (row){
			if (rows.length > 1) {
				showMsg("您选择了多个操作对象，默认操作第一条选中记录！");
			}
			if (editRow != undefined) {
				showMsg("请先保存正在编辑的数据！");
				//结束编辑 自动保存
				//dictionary_datagrid.datagrid('endEdit', editRow);
			}else{
				editRow = dictionary_datagrid.datagrid('getRowIndex', row);
				dictionary_datagrid.datagrid('beginEdit', editRow);
				cancelSelect();
			}
		} else {
			if(editRow != undefined){
				showMsg("请先保存正在编辑的数据！");
			} else{
			    showMsg("请选择要操作的对象！");
			}
		}
	}

	//保存
	function save(rowData) {
		if (editRow != undefined) {
			dictionary_datagrid.datagrid('endEdit', editRow);
		} else {
			showMsg("请选择要操作的对象！");
		}
	}
	
	//取消编辑
	function cancelEdit() {
		cancelSelect();
		dictionary_datagrid.datagrid('rejectChanges');
		editRow = undefined;
		editRowData = undefined;
		dictionaryTypeCode = undefined;
	}
	//取消选择
	function cancelSelect() {
		dictionary_datagrid.datagrid('unselectAll');
	}

	//删除
	function del() {
		var rows = dictionary_datagrid.datagrid('getSelections');
		if (rows.length > 0) {
			if(editRow != undefined){
				showMsg("请先保存正在编辑的数据！");
				return;
			}
			$.messager.confirm('确认提示！', '您确定要删除当前选中的所有行？', function(r) {
				if (r) {
					var ids = new Object();
					for(var i=0;i<rows.length;i++){
						ids[i] = rows[i].id;
					}
					$.post('${ctx}/sys/dictionary!remove.action',{ids:ids},
							function(data) {
								if (data.code == 1) {
									dictionary_datagrid.datagrid('clearSelections');//取消所有的已选择项
									dictionary_datagrid.datagrid('load');//重新加载列表数据
									showMsg(data.msg);//操作结果提示
								} else {
									showAlertMsg(data.msg,'error');
								}
				    }, 'json');
				}
			});
		} else {
			showMsg("请选择要操作的对象！");
		}
	}

	//搜索
	function search() {
		dictionary_datagrid.datagrid('load',eu.serializeObject(dictionary_search_form));
	}
</script>
<div class="easyui-layout" fit="true" style="margin: 0px;border: 0px;overflow: hidden;width:100%;height:100%;">
	
	<!-- 中间部分 列表 -->
	<div data-options="region:'center',split:false,border:false" 
		style="padding: 0px; height: 100%;width:100%; overflow-y: hidden;">
		
		<!-- 列表右键 -->
		<div id="dictionary_menu" class="easyui-menu" style="width:120px;display: none;">
			<div onclick="add();" data-options="iconCls:'icon-add'">新增</div>
			<div onclick="edit();" data-options="iconCls:'icon-edit'">编辑</div>
			<div onclick="del();" data-options="iconCls:'icon-remove'">删除</div>
		</div>
		
	   <!-- 工具栏 操作按钮 -->
	   <div id="dictionary_toolbar">
			<div style="margin-bottom:5px">    
		       <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="add()">新增</a>
				<span class="toolbar-btn-separator"></span>
				<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">编辑</a>
				<span class="toolbar-btn-separator"></span>
				<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a> 
				<span class="toolbar-btn-separator"></span>
				<a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="save()">保存</a> 
				<span class="toolbar-btn-separator"></span>
				<a href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="cancelEdit()">取消编辑</a> 
				<span class="toolbar-btn-separator"></span>
				<a href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="cancelSelect()">取消选中</a> 
		    </div>    
		    <div>   
			     <form id="dictionary_search_form" style="padding: 0px;">
			                               字典类型:<select id="filter_EQS_dictionaryType__code" name="filter_EQS_dictionaryType__code" class="easyui-combobox" ></select> 
					         名称或编码: <input type="text" id="filter_LIKES_name_OR_code" name="filter_LIKES_name_OR_code" placeholder="请输入名称或编码..."  maxLength="25" style="width: 160px"></input> 
						<a href="javascript:search();" class="easyui-linkbutton"
								iconCls="icon-search" plain="true" >查 询</a>  
				</form>  
		    </div>  
		</div>
	   <table id="dictionary_datagrid" toolbar="#dictionary_toolbar" fit="true"></table>

	</div>
</div>