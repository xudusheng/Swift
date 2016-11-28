/**
 * Created by Hmily on 2016/11/27.
 */

import {
    REQUEST_DOING,
    REQUEST_DONE,
    REQUEST_ERROR,
    NEWS_ROOT_URL
} from '../../const/GlobalConst';

import HTTPUtil from '../../HTTPUtil';

export function fetchNewsList(url, id, page=1) {
    return ((dispatch)=>{
        let isLoadMore = (page > 1);
        let params = {'id':id, 'page':page};

        dispatch({'type': REQUEST_DOING});
        HTTPUtil.get(url, params)
            .then((json) => {

                let action = {
                    'type': REQUEST_DONE,
                    'id': id,
                    'isLoadMore': isLoadMore,
                    'result': json.tngou
                };
                dispatch(action);

            }), (error) => {

            dispatch({'type': REQUEST_ERROR})

        }
    });
}

export function fetchNewsClassify(response) {
        HTTPUtil.get(NEWS_ROOT_URL)
            .then((json) => {
                response(true,json);
            }), (error) => {
            response(false,null);
        };
}

