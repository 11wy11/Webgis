function getData() {
	$("#data").val("");
	jQuery.post('../ashx_for_request/getdataset.ashx', {}, function (data) {//data为后台传输过来的数据
		var obj = JSON.parse(data); //将后天传输的数据转换为Json格式
		$("#data").html("");
		$.each(obj.Tables, function (index, table) {//遍历数据集表格，输出数据集的内容
			//根据不同的表名，显示不同的字段。得到特定表，table = obj.Tables[0]
			var tableName = table.Name;
			$.each(table.Rows, function (index, row) {//遍历数据集表格中的行
				$("#data").html($("#data").html() + row.name +row.latlog+"</br>"); //每行的每一个列的内容 在这里我们用row.colname来获取每一行每一列的内容
			});
		});
	});
}
