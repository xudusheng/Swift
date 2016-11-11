/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    Navigator,
    View,
    Text
} from 'react-native';


import ScrollableTabView, {DefaultTabBar} from 'react-native-scrollable-tab-view';

export default class QScrollableTabView extends Component {
    // http://v.juhe.cn/toutiao/index?type=top&key=f2b9c5a8243bc824253119ba09f7759a

    componentDidMount() {
        fetch('http://v.juhe.cn/toutiao/index?type=top&key=f2b9c5a8243bc824253119ba09f7759a', {})
            .then((response)=> {
                console.log(response.json);

            })

    }

    render() {
        return (
            <ScrollableTabView
                renderTabBar={() =>
                    <DefaultTabBar
                        tabStyle={styles.tab}
                        textStyle={styles.tabText}
                    />
                }
                tabBarBackgroundColor="#fcfcfc"
                tabBarUnderlineStyle={styles.tabBarUnderline}
                tabBarActiveTextColor="#3e9ce9"
                tabBarInactiveTextColor="#aaaaaa"
            >

                <View style={{flex: 1, backgroundColor: 'red', justifyContent: 'center', alignItems: 'center'}}
                      tabLabel='段子手'><Text>段子手</Text></View>
                <View style={{flex: 1, backgroundColor: 'green', justifyContent: 'center', alignItems: 'center'}}
                      tabLabel='财经迷'><Text>财经迷</Text></View>
                <View style={{flex: 1, backgroundColor: 'blue', justifyContent: 'center', alignItems: 'center'}}
                      tabLabel='美食家'><Text>美食家</Text></View>

            </ScrollableTabView>
        );
    }
}


const styles = StyleSheet.create({
    tab: {
        paddingBottom: 0
    },
    tabText: {
        fontSize: 16
    },
    tabBarUnderline: {
        backgroundColor: '#3e9ce9',
        height: 1,
    }
});