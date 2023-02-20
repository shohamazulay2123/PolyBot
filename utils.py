from pytube import YouTube
from pytube import Search

def search_youtube_videos(query, num_results=1):
    """
    This function searches Youtube for videos based on the given query and returns details about the first num_results videos
    :param query: string of the query to search for
    :param num_results: integer representing how many videos to return
    :return: list of dictionaries containing details about the videos
    """
    search_results = Search(query).results[:num_results]
    video_details = []

    for search_result in search_results:
        yt = YouTube(search_result.watch_url)
        details = {
            'title': yt.title,
            'description': yt.description,
            'duration': yt.length,
            'url': yt.watch_url,
            'thumbnail': yt.thumbnail_url,
            'author': yt.author,
            'views': yt.views
        }
        video_details.append(details)

    return video_details
