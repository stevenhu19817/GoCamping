<%@ page contentType="text/html; charset=UTF-8" pageEncoding="BIG5"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.campsitetentstatus.model.CampsiteTentStatusService"%>
<%@ page import="com.campsite.model.*"%>
<%@ page import="com.members.model.*"%>
<%@ page import="com.camporder.model.*"%>
<%@ page import="com.facilities.model.*"%>
<%@ page import="java.util.*"%>
<%
	CampsiteService campsiteService = new CampsiteService();
	CampsiteVO campsiteVO = campsiteService.getOneCampsite(Integer.parseInt(request.getParameter("campId")));
	pageContext.setAttribute("campsiteVO", campsiteVO);
%>
<%
	List<Integer> picturesNum = (List<Integer>) request.getAttribute("picturesNum");
%>
<%
	if (session.getAttribute("id") == null) {
		session.setAttribute("location",
				(request.getRequestURI() + "?campId=" + request.getParameter("campId")));
	}
	pageContext.setAttribute("memberId", (Integer) session.getAttribute("id"));
	pageContext.setAttribute("campId", Integer.parseInt(request.getParameter("campId")));
	Integer guestCount = null;
	try {
		guestCount = new Integer(request.getParameter("guestCount"));
	} catch (NumberFormatException nfe) {
		guestCount = 0;
	}
	CampsiteTentStatusService CTSSvc = new CampsiteTentStatusService();
	pageContext.setAttribute("unavilibleList", CTSSvc.getUnavailibleDatewithGuestNumberOnly(
			Integer.parseInt(request.getParameter("campId")), guestCount));
%>
<%
	MemberService memberService = new MemberService();
	MembersVO membersVO = memberService.findByPrimaryKey(campsiteVO.getMemberId()); //���oMember���q�ܸ��X
%>
<%
	CampOrderService campOrderService = new CampOrderService();
	List<CampOrderVO> campOrderList = campOrderService.getOneCampsiteCampOrderVO(campsiteVO.getCampId());
	pageContext.setAttribute("campOrderList", campOrderList);
%>
<%
	FacilitiesService facilitiesService = new FacilitiesService();
	FacilitiesVO facilitiesVO = facilitiesService.getCampId(Integer.parseInt(request.getParameter("campId")));
	pageContext.setAttribute("facilitiesVO", facilitiesVO);
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>�w�w�S��a</title>
<%@ include file="/template/navbar.jsp"%>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr@4.6.9/dist/flatpickr.min.css">
<!-- �����ܾ� �� CSS -->
<link rel="stylesheet" type="text/css"
	href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<!-- ���J CSS -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/campsite/vendors/bootstrap/css/ReserveCamp.css">
</head>

<body>

	<div class="container text-center my-3">
		<div class="row mx-auto my-auto justify-content-center">
			<div id="recipeCarousel" class="carousel slide"
				data-bs-ride="carousel">
				<div class="carousel-inner" role="listbox">
					<div class="carousel-item active">
						<div class="col-lg-3">
							<div class="card">
								<div class="card-img">
									<img
										src="<%=request.getContextPath()%>/CampsiteGifReader?column=picture1&camp_id=${campsiteVO.campId}"
										class="img-fluid">
								</div>
							</div>
						</div>
					</div>
					<c:forEach var="num" items="${picturesNum}">>
						<div class="carousel-item ">
							<div class="col-lg-3">
								<div class="card">
									<div class="card-img">
										<img
											src="<%=request.getContextPath()%>/CampsiteGifReader?column=picture${num}&camp_id=${campsiteVO.campId}"
											class="img-fluid">
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
				<a class="carousel-control-prev bg-transparent w-aut"
					href="#recipeCarousel" role="button" data-bs-slide="prev"> <span
					class="carousel-control-prev-icon" aria-hidden="true"></span>
				</a> <a class="carousel-control-next bg-transparent w-aut"
					href="#recipeCarousel" role="button" data-bs-slide="next"> <span
					class="carousel-control-next-icon" aria-hidden="true"></span>
				</a>
			</div>
		</div>
	</div>
	<div class="container">
		<div class="row camp-row">
			<div class="col-lg-8 camp-content">
				<div class="row">
					<div class="col-lg-12 camp-title">
						<div class="camp-fac-div">
							<div class="bbq">
								<img
									src="<%=request.getContextPath()%>/campsite/facilities/bbq.png"
									width="40" height="40"> <br> <span> �i�N�� </span>
							</div>
							<div class="wifi">
								<img
									src="<%=request.getContextPath()%>/campsite/facilities/wifi.png"
									width="40" height="40"> <br> <span> ����Wi-Fi </span>
							</div>
							<div class="smoke">
								<img
									src="<%=request.getContextPath()%>/campsite/facilities/smoke.png"
									width="40" height="40"> <br> <span> �T�� </span>
							</div>
							<div class="pet">
								<img
									src="<%=request.getContextPath()%>/campsite/facilities/pet.png"
									width="40" height="40"> <br> <span> �d���͵� </span>
							</div>
						</div>
						<input type="hidden" id="bbq" value="${facilitiesVO.bbq}">
						<input type="hidden" id="wifi" value="${facilitiesVO.wifi}">
						<input type="hidden" id="smoke" value="${facilitiesVO.nosmoke}">
						<input type="hidden" id="pet" value="${facilitiesVO.pets}">
						<h2 class="camp-name ">${campsiteVO.campName}</h2>
						<p class="addr ">�a�}: ${campsiteVO.location}</p>
						<p class="cel ">
							�q��:
							<%=membersVO.getPhone()%></p>
					</div>
					<div class="col-lg-12 camp-detail">
						${campsiteVO.campDescription}</div>
					<div class="col-lg-12 camp-comment">
						<p class="comment">��a����</p>
						<c:forEach var="campOrderVO" items="${campOrderList}">
							<c:set var="comment" value="${campOrderVO.comment}" />
							<c:set var="id" value="${campOrderVO.memberId}" />
							<%
								MemberService memberService1 = new MemberService();
									MembersVO membersVO1 = memberService1
											.findByPrimaryKey(new Integer(pageContext.getAttribute("id").toString()));
							%>
							<c:if test="${not empty comment}">
								<div class="container mt-2 container-comment">
									<div class="row d-flex justify-content-center">
										<div class="col-lg">
											<div class="card p-3">
												<div
													class="d-flex justify-content-between align-items-center">
													<div class="user d-flex flex-row align-items-center">
														<img
															src="data:image/jpg;base64,<%=membersVO1.getBase64Image()%>"
															width="30" class="user-img rounded-circle mr-2"> <span><small
															class="font-weight-bold text-primary"><%=membersVO1.getName()%></small>
															<small class="font-weight-bold">${campOrderVO.comment}</small></span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			<div class="col-lg-4 order-menu">
				<form action="<%=request.getContextPath()%>/campOrder.do"
					method="post">
					<h2 class="camp-price">$${campsiteVO.campPrice}</h2>
					<small class="avg-person">(�C�H�C��)</small>
					<hr>
					<p class="customer-num">�H��:</p>
					<input type="text" class="form-control" name="headCount"
						id="headCount" value="" autocomplete="off">
					<hr>
					<p class="check-in">�J�����:</p>
					<div id="pickr">
						<input class="flatpickr flatpickr-input active" id="selectDate"
							name="date" type="text" placeholder="�п�ܽd��..."
							data-id="rangePlugin" readonly="readonly" autocomplete="off">
					</div>
					<div class="spinner-border text-primary d-none pl-2" role="status"
						id="loading">
						<span class="visually-hidden">Loading...</span>
					</div>
					<input type="hidden" id="from" name="from" value=""> <input
						type="hidden" id="to" name="to" value="">
					<hr>
					<h3 style="padding-bottom: 20px;">
						<p class="total-price">�`��:</p>
						<span id="price"></span>
					</h3>
					<c:if test="${not empty errorMsgs}">
						<ul>
							<c:forEach var="message" items="${errorMsgs}">
								<li style="color: red;">${message}</li>
							</c:forEach>
						</ul>
					</c:if>
					<small style="color: red">${missing}</small> <small
						style="color: red">${noSession}</small> <small style="color: red">${noSpace}</small>
					<small style="color: red">${repeat}</small>
					<hr>
					<div class="d-flex justify-content-center">
						<button style="margin-bottom: 20px;" type="submit"
							class="btn btn-success btn-lg" id="book">�w�w</button>
						<input type="hidden" name="action" value="book"> <input
							type="hidden" name="memberId" id="memberId" value="${memberId}">
						<input type="hidden" name="campId" value="${campId}"> <input
							type="hidden" id="orderDate" name="orderDate" value=""> <input
							type="hidden" id="deadline" name="deadline" value=""> <input
							type="hidden" id="price" name="price" value="">
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="modal fade" id="loginFilter" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">����</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">�b�z�w�w��a�e�A�Х��n�J</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">����</button>
					<a
						href="<%=request.getContextPath()%>/register_and_login/login.jsp"
						class="btn btn-primary">�n�J</a>
				</div>
			</div>
		</div>
	</div>
	<!-- ���JSlider �� JS -->
	<script>
	let items = document.querySelectorAll('.carousel .carousel-item')

	items.forEach((el) => {
	    const minPerSlide = 3
	    let next = el.nextElementSibling
	    for (var i = 1; i < minPerSlide; i++) {
	        if (!next) {
	            // wrap carousel by using first child
	            next = items[0]
	        }
	        let cloneChild = next.cloneNode(true)
	        el.appendChild(cloneChild.children[0])
	        next = next.nextElementSibling
	    }
	})
	</script>
	<script>
// 	window.onload =
// 	    function() {
// 	        var olgiv = document.getElementsByClassName("order-menu")[0],
// 	            H = -75,
// 	            Y = olgiv
// 	        while (Y) {
// 	            H += Y.offsetTop;
// 	            Y = Y.offsetParent;
// 	        }
// 	        window.onscroll = function() {
// 	            var s = document.body.scrollTop || document.documentElement.scrollTop
// 	            if (s > H) {
// 	                olgiv.style = "position:fixed;top:75px;right:113px"
// 	            } else {
// 	                olgiv.style = ""
// 	            }
// 	        }
// 	    }
	</script>
	<%@ include file="/template/script.html"%>
	<script type="text/javascript"
		src="https://cdn.jsdelivr.net/npm/flatpickr@4.6.9/dist/flatpickr.min.js"></script>
	<script type="text/javascript">
	$("#book").click(function (e) {
		if ($("#memberId").val() == '') {
			event.preventDefault();
			$("#loginFilter").modal("show");
		}
	})
		$(document).ready(function() {
			var today = new Date();
			var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
			var deadline = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+(today.getDate()+2);
			var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
			console.log(date);
			$("#orderDate").val(date+' '+time);
			$("#deadline").val(deadline+' '+time);
		})
		let daysBetween;
		const flatpickr = $("#selectDate").flatpickr(
				{
					mode: "range",
					altInput: true,
					altFormat: "F j",
					dateFormat: "Y-m-d",
					minDate: "today",
					maxDate: new Date().fp_incr(60), // 30 days from now
					showMonths : 2,
					disable: ${unavilibleList},
					locale: {
						weekdays: {
							shorthand: [ "��", "�@", "�G", "�T", "�|", "��",
									"��" ],
							longhand: [ "��", "�@", "�G", "�T", "�|",
									"��", "��", ],
						},
						months: {
							shorthand: [ "1��", "2��", "3��", "4��", "5��", "6��",
									"7��", "8��", "9��", "10��", "11��", "12��", ],
							longhand: [ "1��", "2��", "3��", "4��", "5��", "6��",
									"7��", "8��", "9��", "10��", "11��", "12��", ],
						},
						rangeSeparator: " �� ",
						weekAbbreviation: "�g",
						scrollTitle: "�u�ʤ���",
						toggleTitle: "�I������ 12/24 �p�ɮɨ�",
					},
					onChange: function(dates) {
				        if (dates.length == 2) {
				            let start = flatpickr.formatDate(dates[0],"Y-m-d");
				            let end = flatpickr.formatDate(dates[1], "Y-m-d");
				            $("#from").val(start);
				            $("#to").val(end);				            
				            if (start && end) {
				                console.log({ start, end });
				              }
				            let newStart = new Date(start).getTime();
				            let newend = new Date(end).getTime();
				            daysBetween = eval((newend - newStart)/86400/1000);
				            console.log(daysBetween);
				            if (daysBetween != null && $("#headCount").val() > 0) {
				    			let price = daysBetween * $("#headCount").val() * ${campsiteVO.campPrice};
				    			$("#price").text('$'+price);
				    			$("[name='price']").val(price);
				    			$("#headCounts").val($("#headCount").val());
				    		}
				        }
				    }
				});
		$("#headCount").change(function() {	
		if (daysBetween != null && $("#headCount").val() > 0) {
			let price = daysBetween * $("#headCount").val() * ${campsiteVO.campPrice};
			$("#price").text(price);
			$("[name='price']").val(price);
			}
		let campId = $("[name='campId']").val();
		let totalGuest = $("#headCount").val();
		let json = [campId, totalGuest];
		console.log(json);
		$.ajax({
            type: "post",
            url: "<%=request.getContextPath()%>/availibleDate",
            contentType: "application/json",
            data: JSON.stringify(json),
            beforeSend: function () {
				$("#pickr").addClass("d-none");
				$("#loading").toggleClass("d-none");
				$(':input[type="submit"]').prop('disabled', true);
			},
            success: function (response) {
            	var array = JSON.parse(response);
            	flatpickr.clear();
            	$("#price").text("");
            	flatpickr.set("disable", array);
            	$("#pickr").toggleClass("d-none");
				$("#loading").toggleClass("d-none");
				$(':input[type="submit"]').prop('disabled', false);

             },
        });
		})
	</script>
	<script>
		if ($("#bbq").val() == 0) {
			$(".bbq").addClass("d-none");
		}
		if ($("#wifi").val() == 0) {
			$(".wifi").addClass("d-none");
		}
		if ($("#smoke").val() == 0) {
			$(".smoke").addClass("d-none");
		}
		if ($("#pet").val() == 0) {
			$(".pet").addClass("d-none");
		}
	</script>
	<!-- �����ܾ� �� JS -->
	<script type="text/javascript"
		src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
	<script type="text/javascript"
		src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
	<script type="text/javascript"
		src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
	<!-- ���J Font Awesome -->
	<script src="https://kit.fontawesome.com/846e361093.js"
		crossorigin="anonymous"></script>
	<!-- ���J JS -->
	<script
		src="<%=request.getContextPath()%>/campsite/vendors/bootstrap/js/ReserveCamp.js"></script>
</body>

</html>