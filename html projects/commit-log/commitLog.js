
// HOW TO USE:
/**
 * 1. Create an element with id="commit-log-list".
 * 2. Give said element a "data-repo-name" attribute, with its value being
 *    the name of the GitHub repository you want to display the commits of.
 * 3. Give said element a "data-repo-owner" attribute, with its value being
 *    the username of the repository's owner.
 * 4. Import this script in your page
 * 5. Below is the template generation for the log's elements. Analyze it to find
 *    classes you can user for styling.
 */
const commitLogListElementTemplate = document.createElement('template')
commitLogListElementTemplate.id = "commit-log-list-element-template"
commitLogListElementTemplate.innerHTML = '' +
	'<li class="commit-log-list-element">' +
		'<div>' +
			'<p class="author-data">' +
				'<img class="author-pfp" src="">' +
				'<a class="author-username"></a>' +
			'</p>' +
		'</div>' +
		'<div>' +
			'<h1 class="commit-sha-id"></h1>' +
			'<p class="commit-description"></p>' +
			'<a class="commit-html-url">View on GitHub</a>' +
		'</div>' +
		'<div>' +
			'<p>' +
				'<span class="commit-date"></span> • ' +
				'<span class="commit-time"></span> • ' +
				'<span class="commit-sha"></span>' +
			'</p>' +
		'</div>' +
	'</li>' +
''


const commitLogList = document.getElementById('commit-log-list')
const repositoryName = commitLogList.dataset.repoName
const repositoryOwner = commitLogList.dataset.repoOwner


function addCommitLogElement(commit) {
	const commitDate = new Date(commit.commit.author.date)
	commit.sha_id = commit.sha.slice(0,7)

	const e = compileHTMLTemplate(commitLogListElementTemplate, {
		'.author-username' : commit.commit.author.name,
		'.commit-sha-id' : commit.sha_id,
		'.commit-description' : commit.commit.message,
		'.commit-date' : `${commitDate.getDate()}/${commitDate.getMonth()+1}/${commitDate.getFullYear()}`,
		'.commit-time' : `${commitDate.getHours()}:${commitDate.getMinutes()}:${commitDate.getSeconds()}`,
		'.commit-sha' : commit.sha
	}, {
		'.author-pfp' : {'src':commit.author.avatar_url},
		'.author-username' : {'title':commit.author.login, 'href':commit.author.html_url},
		'.commit-html-url' : {'href':commit.html_url}
	})

	commitLogList.appendChild(e)
}


fetch(`https://api.github.com/repos/${repositoryOwner}/${repositoryName}/commits`)
	.then(res => res.json())
	.then(commits => {
		for (const commit of commits) {
			addCommitLogElement(commit)
		}
	})