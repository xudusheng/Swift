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

export function fetchNewsClassify() {
    return ((dispatch)=>{
        let isLoadMore = (page > 0);
        dispatch({'type': REQUEST_DOING});
        HTTPUtil.get(NEWS_ROOT_URL)
            .then((json) => {
                let action = {
                    'type': REQUEST_DONE,
                    'result': json.tngou
                };
                dispatch(action);

            }), (error) => {
            dispatch({'type': REQUEST_ERROR})
        }
    });
}


