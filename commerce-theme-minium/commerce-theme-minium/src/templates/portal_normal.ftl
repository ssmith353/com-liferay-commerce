<!DOCTYPE html>
<#include init />
<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">
<head>
	<title>${the_title} - ${company_name}</title>

	<meta content="initial-scale=1.0, width=device-width" name="viewport" />

	<script type="text/javascript" src="${javascript_folder}/intersection-observer.js"></script>

	<script>
		function extendTheSession() {
			if (window.Liferay && window.Liferay.Session && window.Liferay.Session.extend) {
				window.Liferay.Session.extend();

				console.log("we extended the session");
			}
		}
	</script>

	<script>
		setInterval(() => {extendTheSession()}, 5000);
	</script>
	<@liferay_util["include"] page=top_head_include />
</head>

<body class="${css_class} ${wrapper_class_name}">
	<#if show_dockbar>
		<div class="liferay-top">
			<@liferay_ui["quick-access"] contentId="#main-content" />

			<@liferay_util["include"] page=body_top_include />

			<@liferay.control_menu />
		</div>
	</#if>


		<main class="minium minium-frame" id="minium">
		<div class="minium-frame__sidebar">
			<#include "${full_templates_path}/sidebar.ftl" />
		</div>

		<div class="minium-frame__topbar">
			<#include "${full_templates_path}/topbar.ftl" />
		</div>

		<div class="minium-frame__content js-scroll-area">
			<a name="minium-top"></a>

			<div class="${minium_content_css_class}">
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

		<#--  The toolbar is needed to create the shadow when scrolling  -->

		<div class="minium-frame__toolbar"></div>

		<div class="minium-frame__overlay">
			<@liferay_commerce_ui["search-results"] />
		</div>
	</main>

	<div class="liferay-bottom">
		<@liferay_util["include"] page=body_bottom_include />
		<@liferay_util["include"] page=bottom_include />
	</div>
</body>
</html>