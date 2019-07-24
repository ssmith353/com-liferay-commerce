<!DOCTYPE html>
<#include init />
<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">
<head>
	<title>${the_title} - ${company_name}</title>

	<meta content="initial-scale=1.0, width=device-width" name="viewport" />

	<link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">

	<script type="text/javascript" src="${javascript_folder}/intersection-observer.js"></script>
	<@liferay_util["include"] page=top_head_include />
</head>

<body class="speedwell ${css_class}">
	<div class="liferay-top">
		<@liferay_ui["quick-access"] contentId="#main-content" />
		<@liferay_util["include"] page=body_top_include />
		<@liferay.control_menu />
	</div>

	<main class="speedwell-frame" id="speedwell">
		<div class="speedwell-frame__topbar">
			<#include "${full_templates_path}/topbar.ftl" />
		</div>

		<div class="speedwell-frame__content">
			<a name="speedwell-top"></a>

			<div class="container-fluid speedwell-content">
				<#if selectable>
					<@liferay_util["include"] page=content_include />
				<#else>
					${portletDisplay.recycle()}
					${portletDisplay.setTitle(the_title)}

					<@liferay_theme["wrap-portlet"] page="portlet.ftl">
						<@liferay_util["include"] page=content_include />
					</@>
				</#if>
			</div>
		</div>

		<footer class="speedwell-footer">
			<div class="speedwell-footer__info"></div>
			<div class="speedwell-footer__menu">
				<section>
					<h2>COMPANY</h2>
					<nav> <a href="#">About Us</a> <a href="#">Work Here</a> <a href="#">Team</a> <a href="#">Stories</a> </nav>
				</section>
				<section>
					<h2>SELF-SERVICE</h2>
					<nav>  <a href="#">FAQs</a><a href="#">Warranties</a> <a href="#">Repair Center</a>  </nav>
				</section>
				<section>
					<h2>ORDERS</h2>
					<nav> <a href="#">Shipping Policy</a> <a href="#">Return Policy</a> <a href="#">Payments</a> <a href="#">Promotions</a> </nav>
				</section>
				<section>
					<h2>CONTACT</h2>
					<nav> Customer Service<br>1-800-246-2634<br><a href="#">Locate Auto Parts Stores Near You</a></nav>
				</section>
			</div>
			<div class="speedwell-footer__closing">
				<img alt="" class="logo" src="/image/layout_set_logo?img_id=42922&amp;t=1563923869871">
				<nav> <a href="#">Privacy Policy</a> <a href="#">Terms and Conditions</a> <a href="#">Legal Notice Patents</a> </nav>
				© 2019 Speedwell
			</div>
		</footer>
	</main>

	<div class="liferay-bottom">
		<@liferay_util["include"] page=body_bottom_include />
		<@liferay_util["include"] page=bottom_include />
	</div>
</body>
</html>