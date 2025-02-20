
function clamp(n, min, max) {
	return Math.min(max, Math.max(min, n));
}

function _new_cloud_bubble() {
	const container = document.createElement("div")
	container.classList.add("cloud-bubble")

	container.style.animationDirection = Math.random() > 0.5 ? 'normal' : 'reverse'
	container.style.transformOrigin = `center ${Math.random() > 0.5 ? '25%' : '75%'}`
	container.style.animationDelay = (Math.random() * 10) + 's'
	container.style.width = container.style.height = `${clamp(Math.random(), .5, 1)*35}px`

	return container
}

const cloud_container = document.getElementById('cloud-container')
for (let i = 0; i < 10; i++) {
	cloud_container.appendChild(_new_cloud_bubble())
}