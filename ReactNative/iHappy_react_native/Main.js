/**
 * Created by Hmily on 2016/11/26.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    Navigator,
} from 'react-native';
import SideMenu from 'react-native-side-menu'
import ContentContainer from './ContentContainer'

export default class Main extends Component {

    closeControlPanel = () => {
        this._drawer.close();
    };
    openControlPanel = () => {
        this._drawer.open();
    };

    render() {
        // let navigationBar =
        //     <Navigator.NavigationBar
        //         style={{backgroundColor:'red'}}
        //         routeMapper={this.navigationBarRouteMapper()}/>;

        return (
            <View style={{flex:1}}>
                <Navigator
                    style={{flex:1}}
                    initialRoute={{component: ContentContainer}}
                    configureScene={()=>Navigator.SceneConfigs.PushFromRight}
                    renderScene={(route, navigator)=><route.component navigator={navigator} {...route.passProps} />}
                />
            </View>
        )
    };


    //TODO:导航栏的Mapper
    navigationBarRouteMapper(){
        var navigationBarRouteMapper = {
            // 左键
            LeftButton(route, navigator, index, navState) {
                if (index === 0) {
                    return null;
                }
                return (
                    <View style={styles.navContainer}>
                        <TouchableOpacity onPress={()=>navigator.pop()}>
                            <Text style={styles.title}>
                                返回
                            </Text>
                        </TouchableOpacity>
                    </View>
                );
            },
            // 右键
            RightButton(route, navigator, index, navState) {
                // ...
            },
            // 标题
            Title(route, navigator, index, navState) {
                if (route.title) {
                    return (
                        <View style={styles.navContainer}>
                            <TouchableOpacity onPress={()=>{}}>
                                <Text style={styles.title}>
                                    {route.title}
                                </Text>
                            </TouchableOpacity>
                        </View>
                    );
                } else {
                    return null;
                }
            }
        };
        return navigationBarRouteMapper;
    }
}

const styles = StyleSheet.create({
    navContainer: {
        margin: 13,
    },
    title: {
        // marginTop:20,
        fontSize: 17
    }
});
