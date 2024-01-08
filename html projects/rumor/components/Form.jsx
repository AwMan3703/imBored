import Link from "next/link";

const Form = ({ type, post, setPost, submitting, handleSubmit }) => {
  return (
    <section className='w-full max-w-full flex-start flex-col'>
      <h1 className='head_text text-left'>
        <span className='blue_gradient'>{type.replace(type[0], type[0].toUpperCase())} a Post</span>
      </h1>
      <p className='desc text-left max-w-md'>
        {type.toLowerCase()=='create' &&
        'Share amazing ideas with the world, and let your imagination run wild.' +'\n'+
        'Post something for all other users or just your followers!'}
        {type.toLowerCase()=='edit' &&
        'Edit your post.' +'\n'+
        'Its content will be updated within 2 minutes for all Rumor users.'}
      </p>

      <form
        onSubmit={handleSubmit}
        className='mt-10 w-full max-w-2xl flex flex-col gap-7 glassmorphism'
      >
        <label>
          <span className='font-satoshi font-semibold text-base text-gray-700'>
            What's happening?
          </span>

          <textarea
            value={post.prompt}
            onChange={(e) => setPost({ ...post, content: e.target.value })}
            placeholder='Tell something to other Rumor users...'
            required
            className='form_textarea '
          />
        </label>

        <label>
          <span className='font-satoshi font-semibold text-base text-gray-700'>
            Add some Tags:<br/>
            <span className='font-normal'>
              (Tags are used to categorize your post and make it easier to find)
            </span>
          </span>
          <input
            value={post.tag}
            onChange={(e) => setPost({ ...post, tag: e.target.value })}
            type='text'
            placeholder='Add some #Tags...'
            required
            className='form_input'
          />
        </label>

        <div className='flex-end mx-3 mb-5 gap-4'>
          <Link href='/' className='text-gray-500 text-sm'>
            Cancel
          </Link>

          <button
            type='submit'
            disabled={submitting}
            className='px-5 py-1.5 text-sm bg-black rounded-full text-white'
          >
            {submitting ? `${type}ing...` : type}
          </button>
        </div>
      </form>
    </section>
  );
};

export default Form;