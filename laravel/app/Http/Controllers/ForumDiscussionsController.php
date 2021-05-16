<?php

namespace App\Http\Controllers;

use App\Models\ForumDiscussions;
use Illuminate\Http\Request;

class ForumDiscussionsController extends Controller
{
    /**
     * Remove the specified resource from storage.
     *
     * @param  Illuminate\Http\Request $r
     * @param  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $r, $code, $id)
    {
        if ($id)
        {
            $forumDiscussions = ForumDiscussions::where('id', $id);
            if ($forumDiscussions->exists())
            {
                $forum_id = $forumDiscussions->first()->forum_id;
                $replies = ForumDiscussions::where('reply_id', $id);
                if ($forumDiscussions->delete())
                {
                    if ($replies->exists()){
                        $replies->delete();
                    }
                        // refresh forum info
                        file_get_contents(sprintf("%s/api/forum/%d/refresh/0/%s", env('APP_SOCKET_URL'), $forum_id, env('CALLBACK_UPDATE_SERVICE')));

                    return response()->json(['message' => "This Comment successfully deleted."], 200);
                }
            }
        }
        return response()->json(['message' => "Comment is not found."], 404);
    }
}
